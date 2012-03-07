package org.cnio.appform.jaas;


import java.util.Properties;
import java.util.List;
import java.util.Hashtable;

import java.io.FileInputStream;

import javax.security.auth.login.AppConfigurationEntry;
import javax.security.auth.login.Configuration;

public class AppJaasConfiguration extends Configuration {

//	private static final String PROPERTIES_PATH = "/usr/local/"
	private static String propertiesFile;
	
	private static final String MODULE_KEY = "loginModule";
	private static final String FLAG_KEY = "flag";
	private static final String OPTIONS_KEY = "options";
	
	private static AppJaasConfiguration config;
	private static String propsFilePath;
		
	
	public static void init (String propsPath) {
		config = new AppJaasConfiguration ();
		Configuration.setConfiguration(config);
		
//		propsFilePath = propsPath;
		propertiesFile = propsPath;
	}
	
	
	public static Configuration getConfiguration() {
		
		return config;
	}
	
	
	public void setPropsFilePath (String path) {
		propsFilePath = path;
	}
	
	
	@Override
	public AppConfigurationEntry[] getAppConfigurationEntry(String name) {
		Properties props = new Properties ();
		
		try {
			String moduleName, ctrlflag, options;
			props.load(new FileInputStream (propertiesFile));
			
			moduleName = props.getProperty(MODULE_KEY);
			
			ctrlflag = props.getProperty(FLAG_KEY);
			AppConfigurationEntry.LoginModuleControlFlag flag =
					flagFromValue (ctrlflag);
			
			options = props.getProperty(OPTIONS_KEY);
System.out.println("moduleName: "+moduleName+" - "
									+"flag: "+ctrlflag+" - opts: "+options);

			String[] sepOpts = options.split(",");
			Hashtable<String,String> hashOpt = new Hashtable ();
			for (String opt: sepOpts) {
				String[] pair = opt.split("=");
				hashOpt.put(pair[0], pair[1]);
			}
			
			AppConfigurationEntry entry = 
						new AppConfigurationEntry (moduleName,flag,hashOpt);
			
			AppConfigurationEntry[] entries = {entry};
/*			
			String loginModuleClass = rs.getString("loginModuleClass"); 
      String controlFlagValue = rs.getString("controlFlag"); 
      AppConfigurationEntry.LoginModuleControlFlag controlFlag =  
        resolveControlFlag(controlFlagValue); 
      AppConfigurationEntry entry = new AppConfigurationEntry( 
          loginModuleClass, controlFlag, new HashMap());
*/			
			
			return entries;
		}
		catch (java.io.IOException ioEx) {
			ioEx.printStackTrace();
		}
		
		return null;
	}

	
	
	@Override
	public void refresh() {
		// TODO Auto-generated method stub

	}
	
	
	private AppConfigurationEntry.LoginModuleControlFlag flagFromValue (String flag) {
		if (flag.compareToIgnoreCase("REQUIRED") == 0)
			return AppConfigurationEntry.LoginModuleControlFlag.REQUIRED;
		
		if (flag.compareToIgnoreCase("REQUISITE") == 0) {
			return AppConfigurationEntry.LoginModuleControlFlag.REQUISITE;
		}
		
		if (flag.compareToIgnoreCase("OPTIONAL") == 0) {
			return AppConfigurationEntry.LoginModuleControlFlag.OPTIONAL;
		}
		
		if (flag.compareToIgnoreCase("SUFFICIENT") == 0) {
			return AppConfigurationEntry.LoginModuleControlFlag.SUFFICIENT;
		}
		
		return null;
	}

}
