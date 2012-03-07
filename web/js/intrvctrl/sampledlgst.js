/*
Ext.BLANK_IMAGE_URL = '../../js/lib/ext/resources/images/default/s.gif';

// declaring the namespace for all this mini-application
Ext.ns ('Sampledlg');
*/
Employee = Ext.extend(Ext.util.Observable, {
    constructor: function(config){
        this.name = config.name;
        this.addEvents({
            "fired" : true,
            "quit" : true
        });

        // Copy configured listeners into *this* object so that the base class's
        // constructor will add them.
        this.listeners = config.listeners;

        // Call our superclass constructor to complete construction process.
        Employee.superclass.constructor.call(config)
    }
});


Sampledlg.AppCfg = Ext.extend (Ext.util.Observable, {
	constructor: function (config) {
		
	}
});


// Sampledlg.SAMPLE_CODE_SIZE = 11

//////////////// STORES ///////////////////////////////////////////////////

// SUBJECT TYPE DATA STUFF ////////////////////////////////////////////////
Sampledlg.jsonType = {
	types: [
		{id:1, name:'Case', cod:'01'},
		{id:2, name:'Control', cod:'02'},
		{id:3, name:'Family', cod:'03'}
	]
}

Sampledlg.typeJsonSt = new Ext.data.JsonStore ({
// json reader config
	root: 'types',
	fields: ['id', 'name', 'cod'],
	idProperty: 'id',

// this store config
	storeId: 'typeStore',
	data: Sampledlg.jsonType,
	autoDestroy: true
});


// Preconfigured store to get the groups from server
// Ext.extend (superclass, overridesObject)
Sampledlg.GrpStore = Ext.extend (Ext.data.JsonStore, {
// constructor for this class, inside the superclass consturctor will be called
	constructor: function (config) {
		var myProxy = new Ext.data.HttpProxy ({
			url: APPNAME+'/servlet/MngGroupsServlet',
			method: 'GET',
		});
		
		var innCfg = {
			root: 'groups',
			fields: ['id', 'name', 'cod'],
			idProperty: 'id',
		
		// this store config
		//	data: grpData,
			storeId: config.storeId,
			/*
			proxy: !config.data? new Ext.data.HttpProxy({
				url: APPNAME+'/servlet/MngGroupsServlet',
				method: 'GET',
			}): undefined,
			*/
			proxy: config.data? undefined: myProxy,
			baseParams: {'what':'s', 'usrid': config.usrid},
			autoDestroy: true,
			
			listeners: {
				load: IntroDlg.setSecondaryGrp
			}
		};
		
/*
 * This is the normal constructor extension to define very basic preconfigured classes
 * What is done here is make a call to the superclass' constructor
 * From developer.mozilla.org, first parameter call method of a function object
 * is such that it determines the value of this inside fun
 * 
 * The second parameter(s) are the normal "function parameters".
 * Here is an object returned by Ext.apply (target, source), which copies 
 * (mostly, merge) the properties from source to target
 * 
 * In this way, the superclass is configured with the parameters defined (or passed)
 * in this method
 */
		Sampledlg.GrpStore.superclass.constructor.call (this, Ext.apply (innCfg, config));
	}, // eo constructor
	
	
	onLoad: function (store, records, options) {
//	console.info('onLoad: ');
	
		var grpCombo = Ext.getCmp ('comboGrp');
		if (IntroDlg.appCfg.grpcode != undefined) {
	// console.info ('setting grpcode: '+objCfg.grpcode);
			grpCombo.setValue(IntroDlg.appCfg.grpcode);
		}
	}
	
});
//////////////// END STORES ///////////////////////////////////////////////