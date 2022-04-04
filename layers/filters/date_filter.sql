{{ config(	
    title='Date Filter',	
    type='date_picker',
    picker_mode='range',  
    output_filters={ 
        'start_date': 'start_date',		
        'end_date': 'end_date', 		
        'prev_start_date': 'prev_start_date',		
        'prev_end_date': 'prev_end_date',		
        'date_preset': 'date_preset',		
        'previous_mode': 'previous_mode' },
	persist_filters=true,
    hide_presets=false
)}}