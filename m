Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM01-BY2-obe.outbound.protection.outlook.com
 (mail-by2nam01on0716.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe42::716])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37B851A1E8B
 for <linux-nvdimm@lists.01.org>; Thu, 13 Oct 2016 18:25:41 -0700 (PDT)
From: "Boylston, Brian" <brian.boylston@hpe.com>
Subject: RE: [ndctl PATCH] libndctl: fix 'type-pun' warnings with hpe1 commands
Date: Fri, 14 Oct 2016 01:25:40 +0000
Message-ID: <CS1PR84MB0119A171C9653C9B42C2BD5A8EDF0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
References: <147630484183.28641.3160414367749359017.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4gAGroaoZBhKtSxptj+D7WYSiEnaP5-vEaH=nAMfwcb1Q@mail.gmail.com>
In-Reply-To: <CAPcyv4gAGroaoZBhKtSxptj+D7WYSiEnaP5-vEaH=nAMfwcb1Q@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams wrote on 2016-10-13:
> On Wed, Oct 12, 2016 at 1:40 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> Fix warnings of the form:
>> 
>>     libndctl-hpe1.c: In function 'hpe1_smart_valid':
>>     libndctl-hpe1.c:78:15: warning: dereferencing type-punned pointer will
>>         break strict-aliasing rules [-Wstrict-aliasing]
>>         CMD_HPE1(cmd)->gen.nd_family != NVDIMM_FAMILY_HPE1 ||
>>         ^
>>     libndctl-hpe1.c:79:15: warning: dereferencing type-punned pointer will
>>         break strict-aliasing rules [-Wstrict-aliasing]
>>         CMD_HPE1(cmd)->gen.nd_command != NDN_HPE1_CMD_SMART ||
>>         ^
>>     libndctl-hpe1.c: In function 'hpe1_cmd_smart_get_flags':
>>     libndctl-hpe1.c:93:55: warning: dereferencing type-punned pointer will
>>         break strict-aliasing rules [-Wstrict-aliasing]
>>     libndctl-hpe1.c:93:55: warning: dereferencing type-punned pointer will
>>         break strict-aliasing rules [-Wstrict-aliasing]
>>     libndctl-hpe1.c: In function 'hpe1_cmd_smart_get_health':
>>     libndctl-hpe1.c:121:56: warning: dereferencing type-punned pointer will
>>         break strict-aliasing rules [-Wstrict-aliasing]
>>     libndctl-hpe1.c:121:56: warning: dereferencing type-punned pointer will
>>         break strict-aliasing rules [-Wstrict-aliasing]
>> ...for distributions that include "-Wstrict-aliasing" in CFLAGS.
>> 
>> Cc: Brian Boylston <brian.boylston@hpe.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> 
> Brian, it occurs to me that I do not have unit test coverage for hpe1
> command functionality.  Can you confirm that this patch does not break
> anything?

Yes!  I actually tested this earlier today using the pending branch,
and it seems to work fine:

# ndctl --version
54.44.g4a4c09e
# ndctl list -D -i -H
[
  {
    "dev":"nmem1",
    "id":"802c-0f-1612-122f8182",
    "state":"disabled",
    "health":{
      "health_state":"fatal",
      "temperature_celsius":25.000000,
      "spares_percentage":99,
      "alarm_temperature":false,
      "alarm_spares":false,
      "temperature_threshold":50.000000,
      "spares_threshold":20,
      "life_used_percentage":29,
      "shutdown_state":"dirty"
    }
  },
  {
    "dev":"nmem3",
    "id":"802c-0f-1612-122f81da",
    "state":"disabled",
    "health":{
      "health_state":"ok",
      "temperature_celsius":25.000000,
      "spares_percentage":99,
      "alarm_temperature":false,
      "alarm_spares":false,
      "temperature_threshold":50.000000,
      "spares_threshold":20,
      "life_used_percentage":29,
      "shutdown_state":"clean"
    }
  },
...

nmem1 here has an injected error.

> 
> For extra credit, I wouldn't say no if you instrumented the kernel's
> nfit_test infrastructure to provide sample hpe1 data payload results.

Sure, when I get a chance, I'll take a look.


Thanks!
Brian

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
