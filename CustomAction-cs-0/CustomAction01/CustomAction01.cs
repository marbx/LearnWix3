using Microsoft.Deployment.WindowsInstaller;
using Microsoft.Tools.WindowsInstallerXml;
using Microsoft.Win32;
using System;
using System.IO;
using System.Text.RegularExpressions;

namespace CustomAction01 {
    public class CustomAction01 : WixExtension {


        public static string get_property_IMCAC(Session session, string key ) {
            // IMMEDIATE means
            //   you can directly access msi properties at session[KEY]
            // keys are case sensitive
            // If key does not exist, its value will be empty
            session.Log("...get_property_IMCAC key {0}", key);
            string val = session[key];
            session.Log("...get_property_IMCAC val {0}", val);
            session.Log("...get_property_IMCAC len {0}", val.Length);
            return val;
        }




        public static string get_property_DECAC(Session session, string key) {
            // DEFERRED means
            //   you may modify the system because the transaction has started
            //   you must access msi properties via CustomActionData[KEY]
            // If key does not exist, the msi will fail to install
            session.Log("...get_property_DECAC key {0}", key);
            string val = session.CustomActionData[key];
            session.Log("...get_property_DECAC val {0}", val);
            session.Log("...get_property_DECAC len {0}", val.Length);
            return val;
        }


        [CustomAction]
        public static ActionResult ReadConfig_IMCAC(Session session) {
            // IMMEDIATE means
            //   you should not modify the system because the transaction has not yet started
            //   reading is fine
            // Just Logging
            session.Log("...Begin ReadConfig_IMCAC");
            string hello1 = get_property_IMCAC(session, "HELLO1");
            session.Log("...End ReadConfig_IMCAC");
            return ActionResult.Success;
        }


        [CustomAction]
        public static ActionResult WriteConfig_DECAC(Session session) {
            // DEFERRED means
            //   you may modify the system because the transaction has started
            // If key does not exist, the msi will fail to install
            // Just Logging
            session.Log("...Begin WriteConfig_DECAC");
            string hello1 = get_property_DECAC(session, "hello1");
            session.Log("...End WriteConfig_DECAC");
            return ActionResult.Success;
        }
    }
}
