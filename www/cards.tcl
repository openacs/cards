
ad_page_contract {
} -query {
}

# prevent this page from being called when not in a community
# (i.e. the main dotlrn instance
if {[empty_string_p [dotlrn_community::get_community_id]]} {
    ad_returnredirect "[dotlrn::get_url]"
}

set context [list [list "one-community-admin" [_ dotlrn.Admin]] [_ dotlrn.Manage_Members]]
set community_id [dotlrn_community::get_community_id]
set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
set admin_p [dotlrn::user_can_admin_community_p -user_id [ad_get_user_id] -community_id $community_id]
set spam_p [dotlrn::user_can_spam_community_p -user_id [ad_get_user_id] -community_id $community_id]
set return_url "[ns_conn url]?[ns_conn query]"
