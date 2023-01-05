use std::ffi::CString;
use std::net::{SocketAddr, ToSocketAddrs};
use std::os::raw::c_char;
use std::path::Path;
use std::time::Duration;

use socket2::{Domain, Socket, Type};
/// No error.
pub const ERR_OK: i32 = 0;
/// Config path error.
pub const ERR_CONFIG_PATH: i32 = 1;
/// Config parsing error.
pub const ERR_CONFIG: i32 = 2;
/// IO error.
pub const ERR_IO: i32 = 3;
/// Config file watcher error.
pub const ERR_WATCHER: i32 = 4;
/// Async channel send error.
pub const ERR_ASYNC_CHANNEL_SEND: i32 = 5;
/// Sync channel receive error.
pub const ERR_SYNC_CHANNEL_RECV: i32 = 6;
/// Runtime manager error.
pub const ERR_RUNTIME_MANAGER: i32 = 7;
/// No associated config file.
pub const ERR_NO_CONFIG_FILE: i32 = 8;

fn to_errno(e: ostrich::Error) -> i32 {
    match e {
        ostrich::Error::Config(..) => ERR_CONFIG,
        ostrich::Error::NoConfigFile => ERR_NO_CONFIG_FILE,
        ostrich::Error::Io(..) => ERR_IO,
        // #[cfg(feature = "auto-reload")]
        // ostrich::Error::Watcher(..) => ERR_WATCHER,
        ostrich::Error::AsyncChannelSend(..) => ERR_ASYNC_CHANNEL_SEND,
        ostrich::Error::SyncChannelRecv(..) => ERR_SYNC_CHANNEL_RECV,
        ostrich::Error::RuntimeManager => ERR_RUNTIME_MANAGER,
    }
}

// pub fn leaf_run(config_path: String) {
//     let values = config_path.split("\\");
//
//     // Print results.
//     // Create a `Path` from an `&'static str`
//     let path = Path::new("");
//
//     // The `display` method returns a `Display`able structure
//     let _display = path.display();
//
//     // `join` merges a path with a byte container using the OS specific
//     // separator, and returns the new path
//     let mut new_path = path.join("");
//     for v in values {
//         new_path = new_path.join(v);
//     }
//
//     // Convert the path into a string slice
//     match new_path.to_str() {
//         None => panic!("new path is not a valid UTF-8 sequence"),
//         Some(s) => {
//             println!("new path is {}", s);
//             start(s.to_string());
//         }
//     }
// }
pub fn leaf_run(
    config_path: String,
    #[cfg(target_os = "windows")] wintun_path: String,
    #[cfg(target_os = "windows")] tun2socks_path: String,
) -> i32 {
    ///option 1
    #[cfg(target_os = "windows")]
    use std::ffi::OsStr;
    #[cfg(target_os = "windows")]
    unsafe fn u8_slice_as_os_str(s: &[u8]) -> &OsStr {
        &*(s as *const [u8] as *const OsStr)
    }
    #[cfg(target_os = "windows")]
    let wintun_path = unsafe {
        u8_slice_as_os_str(wintun_path.as_bytes())
            .to_os_string()
            .into_string()
            .unwrap()
    };

    #[cfg(target_os = "windows")]
    let config_path = unsafe {
        u8_slice_as_os_str(config_path.as_bytes())
            .to_os_string()
            .into_string()
            .unwrap()
    };

    /*     ///option 2
    #[cfg(target_os = "windows")]
    use std::path::{PathBuf};
    #[cfg(target_os = "windows")]
    let wintun_values = wintun_path.split("\\");
    #[cfg(target_os = "windows")]
    let mut wintun_path = PathBuf::new();
    #[cfg(target_os = "windows")]
    for (i,v) in wintun_values.into_iter().enumerate() {
        println!("{}",v);
        if i == 0{
            wintun_path.push(v);
            wintun_path.push("\\");
            continue
        }
        wintun_path = wintun_path.join(v);
    }
    #[cfg(target_os = "windows")]
    let config_values = config_path.split("\\");
    #[cfg(target_os = "windows")]
    let mut config_path = PathBuf::new();
    #[cfg(target_os = "windows")]
    for (i,v) in config_values.into_iter().enumerate() {
        println!("{}",v);
        if i == 0{
            config_path.push(v);
            config_path.push("\\");
            continue
        }
        config_path = config_path.join(v);
    }
    #[cfg(target_os = "windows")]
    let config_path = config_path.to_string_lossy().to_string();
    #[cfg(target_os = "windows")]
    let wintun_path = wintun_path.to_string_lossy().to_string(); */

    let opts = ostrich::StartOptions {
        config: ostrich::Config::File(config_path.to_string()),
    };
    if let Err(e) = ostrich::start(
        opts,
        #[cfg(target_os = "windows")]
        wintun_path,
        #[cfg(target_os = "windows")]
        tun2socks_path,
    ) {
        return to_errno(e);
    }
    ERR_OK
}

pub fn is_running() -> bool {
    ostrich::is_running()
}

pub fn leaf_shutdown() -> bool {
    ostrich::shutdown()
}

pub fn ping(host: String, port: i64) -> String {
    let addr: SocketAddr = format!("{}:{}", &host, port)
        .to_socket_addrs()
        .unwrap()
        .filter(|a| a.is_ipv4())
        .next()
        .unwrap();
    let timeout: Duration = Duration::from_secs(4);
    let start = std::time::Instant::now();
    let socket = Socket::new(Domain::IPV4, Type::STREAM, None).unwrap();
    let res = socket.connect_timeout(&addr.into(), timeout);
    let elapsed = std::time::Instant::now().duration_since(start);
    match res {
        Ok(_) => {
            println!("Connected to {} in {} ms", &addr, elapsed.as_millis());
            return elapsed.as_millis().to_string();
        }
        Err(e) => {
            println!("Connect to {} failed: {}", &addr, e);
            return "time out".to_string();
        }
    }
    // std::thread::sleep(std::time::Duration::from_secs(1));
}

#[cfg(target_os = "windows")]
pub fn require_administrator() {
    let mut res = winres::WindowsResource::new();
    res.set_manifest(
        r#"
    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <assembly xmlns="urn:schemas-microsoft-com:asm.v1" manifestVersion="1.0">
        <trustInfo xmlns="urn:schemas-microsoft-com:asm.v3">
            <security>
                <requestedPrivileges>
                    <requestedExecutionLevel level="requireAdministrator" uiAccess="false"/>
                </requestedPrivileges>
            </security>
        </trustInfo>
    </assembly>
    "#,
    );
}

#[cfg(target_os = "windows")]
pub fn is_elevated() -> bool {
    extern crate winapi;
    use std::mem;
    use winapi::shared::minwindef::DWORD;
    use winapi::shared::minwindef::LPVOID;
    use winapi::um::processthreadsapi::GetCurrentProcess;
    use winapi::um::processthreadsapi::OpenProcessToken;
    use winapi::um::securitybaseapi::GetTokenInformation;
    use winapi::um::winnt::TokenElevation;
    use winapi::um::winnt::HANDLE;
    use winapi::um::winnt::TOKEN_ELEVATION;
    use winapi::um::winnt::TOKEN_QUERY;
    // based on https://stackoverflow.com/a/8196291
    unsafe {
        let mut current_token_ptr: HANDLE = mem::zeroed();
        let mut token_elevation: TOKEN_ELEVATION = mem::zeroed();
        let token_elevation_type_ptr: *mut TOKEN_ELEVATION = &mut token_elevation;
        let mut size: DWORD = 0;

        let result = OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &mut current_token_ptr);

        if result != 0 {
            let result = GetTokenInformation(
                current_token_ptr,
                TokenElevation,
                token_elevation_type_ptr as LPVOID,
                mem::size_of::<winapi::um::winnt::TOKEN_ELEVATION_TYPE>() as u32,
                &mut size,
            );
            if result != 0 {
                return token_elevation.TokenIsElevated != 0;
            }
        }
    }
    false
}

#[cfg(target_os = "windows")]
pub fn is_app_elevated() -> bool {
    // Use std::io::Error::last_os_error for errors.
    // NOTE: For this example I'm simple passing on the OS error.
    // However, customising the error could provide more context
    use std::io::Error;
    use std::ptr;

    use winapi::um::handleapi::CloseHandle;
    use winapi::um::processthreadsapi::{GetCurrentProcess, OpenProcessToken};
    use winapi::um::securitybaseapi::GetTokenInformation;
    use winapi::um::winnt::{TokenElevation, HANDLE, TOKEN_ELEVATION, TOKEN_QUERY};

    /// On success returns a bool indicating if the current process has admin rights.
    /// Otherwise returns an OS error.
    ///
    /// This is unlikely to fail but if it does it's even more unlikely that you have admin permissions anyway.
    /// Therefore the public function above simply eats the error and returns a bool.
    fn _is_app_elevated() -> Result<bool, Error> {
        let token = QueryAccessToken::from_current_process()?;
        token.is_elevated()
    }

    /// A safe wrapper around querying Windows access tokens.
    pub struct QueryAccessToken(HANDLE);
    impl QueryAccessToken {
        pub fn from_current_process() -> Result<Self, Error> {
            unsafe {
                let mut handle: HANDLE = ptr::null_mut();
                if OpenProcessToken(GetCurrentProcess(), TOKEN_QUERY, &mut handle) != 0 {
                    Ok(Self(handle))
                } else {
                    Err(Error::last_os_error())
                }
            }
        }

        /// On success returns a bool indicating if the access token has elevated privilidges.
        /// Otherwise returns an OS error.
        pub fn is_elevated(&self) -> Result<bool, Error> {
            unsafe {
                let mut elevation = TOKEN_ELEVATION::default();
                let size = std::mem::size_of::<TOKEN_ELEVATION>() as u32;
                let mut ret_size = size;
                // The weird looking repetition of `as *mut _` is casting the reference to a c_void pointer.
                if GetTokenInformation(
                    self.0,
                    TokenElevation,
                    &mut elevation as *mut _ as *mut _,
                    size,
                    &mut ret_size,
                ) != 0
                {
                    Ok(elevation.TokenIsElevated != 0)
                } else {
                    Err(Error::last_os_error())
                }
            }
        }
    }
    impl Drop for QueryAccessToken {
        fn drop(&mut self) {
            if !self.0.is_null() {
                unsafe { CloseHandle(self.0) };
            }
        }
    }

    _is_app_elevated().unwrap_or(false)
}

#[test]
fn test() {
    println!("ping result:{}", ping("google.com".to_string(), 443));
}

#[test]
fn run() {
    // leaf_run("C:\\Users\\myway\\.ostrichConfig\\latest.json".to_string());
    let test = "C:\\Users\\myway\\.ostrichConfig\\latest.json";
    // Call split, using function to test separators.
    let values = test.split("\\");

    // Print results.
    // Create a `Path` from an `&'static str`
    let path = Path::new("");

    // The `display` method returns a `Display`able structure
    let _display = path.display();

    // `join` merges a path with a byte container using the OS specific
    // separator, and returns the new path
    let mut new_path = path.join("");
    for v in values {
        new_path = new_path.join(v);
    }

    // Convert the path into a string slice
    match new_path.to_str() {
        None => panic!("new path is not a valid UTF-8 sequence"),
        Some(s) => println!("new path is {}", s),
    }
}

#[test]
fn next_run() {
    let wintun_path = "E:\\software\\rust\\tun2ostrich\\misc\\wintun.dll";
    let json_file_path = "E:\\software\\rust\\tun2ostrich\\latest.json";
    use std::ffi::OsStr;
    use std::path::{Path, PathBuf};
    unsafe fn u8_slice_as_os_str(s: &[u8]) -> &OsStr {
        // SAFETY: see the comment of `os_str_as_u8_slice`
        &*(s as *const [u8] as *const OsStr)
    }

    // let json_file = unsafe { Path::new(u8_slice_as_os_str(json_file_path.as_bytes())) };

    let json_file = unsafe {
        u8_slice_as_os_str(json_file_path.as_bytes())
            .to_os_string()
            .into_string()
            .unwrap()
    };

    let config = std::fs::read_to_string(json_file).unwrap();
    let json: serde_json::Value = serde_json::from_str(&config).unwrap();
    println!("json: {:?}", json);

    println!("{}", &wintun_path);

    let values = wintun_path.split("\\");

    let mut path = PathBuf::new();

    for (i, v) in values.into_iter().enumerate() {
        println!("{}", v);
        if i == 0 {
            path.push(v);
            path.push("\\");
            continue;
        }
        path = path.join(v);
    }

    // Convert the path into a string slice
    match path.to_str() {
        None => panic!("new path is not a valid UTF-8 sequence"),
        Some(s) => {
            println!("new path is {}", s);
        }
    }
}
