local utils = require("kong.plugins.oidc.utils")
local lu = require("luaunit")

TestToken = require("test.unit.mockable_case"):extend()

function TestToken:setUp() TestToken.super:setUp() end

function TestToken:tearDown() TestToken.super:tearDown() end

function TestToken:test_access_token_missing_in_both_header_and_query()
    local headers = {}
    local uri_args = {}
    _G.ngx = {
        req = {
            get_headers = function() return headers end,
            get_uri_args = function() return uri_args end,
            set_header = function(k, v) headers[k] = v end,
            set_uri_args = function(a) uri_args = a end
        }
    }

    utils.addBearerAccessTokenFromQuery()

    lu.assertNil(headers["Authorization"])
    lu.assertNil(uri_args["access_token"])
end

function TestToken:test_access_token_exists_in_query_but_not_header()
    local headers = {}
    local uri_args = {access_token = "xxx"}
    _G.ngx = {
        req = {
            get_headers = function() return headers end,
            get_uri_args = function() return uri_args end,
            set_header = function(k, v) headers[k] = v end,
            set_uri_args = function(a) uri_args = a end
        }
    }

    utils.addBearerAccessTokenFromQuery()

    lu.assertEquals(headers["Authorization"], "Bearer xxx")
    lu.assertNil(uri_args["access_token"])
end

function TestToken:test_access_token_exists_in_header_but_not_query()
    local headers = {Authorization = "Bearer xxx"}
    local uri_args = {}
    _G.ngx = {
        req = {
            get_headers = function() return headers end,
            get_uri_args = function() return uri_args end,
            set_header = function(k, v) headers[k] = v end,
            set_uri_args = function(a) uri_args = a end
        }
    }

    utils.addBearerAccessTokenFromQuery()

    lu.assertEquals(headers["Authorization"], "Bearer xxx")
    lu.assertNil(uri_args["access_token"])
end

function TestToken:test_access_token_exists_in_both_header_and_query()
    local headers = {Authorization = "Bearer xxx"}
    local uri_args = {access_token = "yyy"}
    _G.ngx = {
        req = {
            get_headers = function() return headers end,
            get_uri_args = function() return uri_args end,
            set_header = function(k, v) headers[k] = v end,
            set_uri_args = function(a) uri_args = a end
        }
    }

    utils.addBearerAccessTokenFromQuery()

    lu.assertTrue(utils.has_bearer_access_token())
    lu.assertEquals(headers["Authorization"], "Bearer xxx")
    lu.assertEquals(uri_args["access_token"], "yyy")
end

lu.run()
