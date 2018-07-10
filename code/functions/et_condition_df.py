#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Jun 19 16:46:11 2018

@author: kgross
"""

import functions.add_path
import os

import pandas as pd

import functions.et_preprocess as preprocess
import functions.et_helper as  helper
import functions.et_make_df as  make_df
from functions.detect_events import make_blinks,make_saccades,make_fixations

import logging



#%% Create complete_condition_df depending on the selected condition for all subjects

def get_condition_df(subjectnames, ets, condition=None, **kwargs):
    # make the df for the large GRID for both eyetrackers and all subjects
    # **kwargs for using different prefix i.e. using a different event detection algorithm, see et_preprocess
    
    # get a logger
    logger = logging.getLogger(__name__)
    
    if condition == None:
        raise ValueError('Condition must not be None. Please specify a condition')    
    
    # create df
    complete_condition_df = pd.DataFrame()
    complete_fix_count_df = pd.DataFrame()
       
    for subject in subjectnames:
        for et in ets:
            logger.critical('Eyetracker: %s    Subject: %s ', et, subject)
            
            # load preprocessed data for one eyetracker and for one subject at a time
            etsamples, etmsgs, etevents = preprocess.preprocess_et(et,subject,load=True,**kwargs)
     
            if condition == 'LARGE_GRID' or  condition == 'LARGE_and_SMALL_GRID':
                
                # adding the messages to the event df (backward merge)                
                merged_events = helper.add_msg_to_event(etevents, etmsgs, timefield = 'start_time', direction='backward')
                 
                if condition == 'LARGE_GRID':
                    # make df for grid condition that only contains ONE fixation per element
                    # (the last fixation before the new element  (used a groupby.last() to achieve that))
                    condition_df = make_df.make_large_grid_df(merged_events)          
                
                elif condition == 'LARGE_and_SMALL_GRID':                  
                    # make df for all grids that only contains ONE fixation per element
                    # (last fixation before the new element is shown)
                    condition_df = make_df.make_all_elements_grid_df(merged_events)                  
                
            
            elif condition == 'FREEVIEW':
                # due to experimental triggers: FORWARD merge to add msgs to the events
                merged_events = helper.add_msg_to_event(etevents, etmsgs.query('condition=="FREEVIEW"'), timefield = 'start_time', direction='forward')
                
                # freeview df
                condition_df, fix_count_df = make_df.make_freeview_df(merged_events)          
                
                # add a column for eyetracker and subject
                fix_count_df['et'] = et
                fix_count_df['subject'] = subject

                # concatenate to the complete fix_count_df                
                complete_fix_count_df = pd.concat([complete_fix_count_df,fix_count_df])     
        
            else:
                raise ValueError('You must specify a known condition.')

            
            # do the stuff that we need to do for all conditions anyways
            # add a column for eyetracker and subject
            condition_df['et'] = et
            condition_df['subject'] = subject
            
            # concatenate the df of one specific conditin and one specific subject to the complete_condition_df
            complete_condition_df = pd.concat([complete_condition_df, condition_df])
 
    
    # set variables to correct dtypes (e.g. from object to categorical)
    # and use full names e.g. el changes to EyeLink 
    complete_condition_df = helper.set_dtypes(complete_condition_df)
    
    # renaming for pretty plotting
    complete_condition_df = helper.set_to_full_names(complete_condition_df)

    
    # Sanity check
    # there must not be any NaN values
    # TODO: solve this problem
    # last time rms caused problems
#    if complete_condition_df.isnull().values.any():
#       logger.error((complete_condition_df.columns[complete_condition_df.isna().any()].tolist()))
#       logger.error((complete_condition_df.rms.mean()))
#       raise ValueError('Some value(s) of the df is NaN')

    
    # TODO: maybe smarter option to write own function for getting the fix_count_df???    ------> later
    # for the freeview condition we return 2 dfs
    if condition == 'FREEVIEW':
        return complete_condition_df, fix_count_df
    
    # for all other condtions we return the complete_condition_df
    else:
        return complete_condition_df