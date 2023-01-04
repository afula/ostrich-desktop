use super::*;
// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_leaf_run(
    port_: i64,
    config_path: *mut wire_uint_8_list,
    wintun_path: *mut wire_uint_8_list,
    tun2socks_path: *mut wire_uint_8_list,
) {
    wire_leaf_run_impl(port_, config_path, wintun_path, tun2socks_path)
}

#[no_mangle]
pub extern "C" fn wire_is_running(port_: i64) {
    wire_is_running_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_leaf_shutdown(port_: i64) {
    wire_leaf_shutdown_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_ping(port_: i64, host: *mut wire_uint_8_list, port: i64) {
    wire_ping_impl(port_, host, port)
}

#[no_mangle]
pub extern "C" fn wire_require_administrator(port_: i64) {
    wire_require_administrator_impl(port_)
}

#[no_mangle]
pub extern "C" fn wire_is_elevated(port_: i64) {
    wire_is_elevated_impl(port_)
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: related functions

// Section: impl Wire2Api

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}
// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturn(ptr: support::WireSyncReturn) {
    unsafe {
        let _ = support::box_from_leak_ptr(ptr);
    };
}
