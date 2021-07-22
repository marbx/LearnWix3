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
            // Immediate means:
            //  - you should not modify the system because the install transaction has not yet started
            //  - reading is fine
            // Perform consistency checks on existing configuration: WriteConfig_DECAC must not fail.
            session.Log("...Begin ReadConfig_IMCAC");
            string Manufacturer  = get_property_IMCAC(session, "Manufacturer");
            string ProductName   = get_property_IMCAC(session, "ProductName");
            string MINION_CONFIG = get_property_IMCAC(session, "MINION_CONFIG");
            string ProgramData   = System.Environment.GetEnvironmentVariable("ProgramData");
            string CONFIGDIR_OLD = @"C:\" + ProductName;
            string CONFIGDIR_NEW =  ProgramData + @"\" + Manufacturer + @"\" + ProductName;
            session["CONFIGDIR_OLD"] = CONFIGDIR_OLD;
            session["CONFIGDIR_NEW"] = CONFIGDIR_NEW;

            string AbortReason = "";
            // Find reasons to abort
            if (MINION_CONFIG.Length == 0) {
                // Care about existing configuration.
                // Consistency check
                if (Directory.Exists(CONFIGDIR_OLD) && Directory.Exists(CONFIGDIR_NEW)) {
                    AbortReason = CONFIGDIR_OLD + " and " + CONFIGDIR_NEW + " must not both exist.";
                }
            } else {
                session.Log("...MINION_CONFIG will replace any existing configuration.");
            }
            if (AbortReason.Length == 0) {
            // Found no reasons to abort, try to read master and id.
            } else {
                // Abort install
                session["AbortReason"] = AbortReason;
            }
            session.Log("...End ReadConfig_IMCAC");
            return ActionResult.Success;
        }


        [CustomAction]
        public static ActionResult WriteConfig_DECAC(Session session) {
            // Deferred means:
            //  - you may modify the system because the install transaction has started
            session.Log("...Begin WriteConfig_DECAC");
            string CONFIGDIR_OLD = get_property_DECAC(session, "CONFIGDIR_OLD");
            string CONFIGDIR_NEW = get_property_DECAC(session, "CONFIGDIR_NEW");
            string MOVE_CONF = get_property_DECAC(session, "MOVE_CONF");
            string configOld = CONFIGDIR_OLD + @"\" + "conf" + @"\" + "a.config";
            string configNew = CONFIGDIR_NEW + @"\" + "conf" + @"\" + "a.config";
            session.Log("...configOld " + configOld);
            session.Log("...configNew " + configNew);
            if (MOVE_CONF == "1" && Directory.Exists(CONFIGDIR_OLD)) {
                session.Log("...moving conf to ProgramData");
                session.Log("...new path " + CONFIGDIR_NEW);
            }
            session.Log("...End WriteConfig_DECAC");
            return ActionResult.Success;
        }
    }
}
