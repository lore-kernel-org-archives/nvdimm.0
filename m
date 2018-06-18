Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1FD8021106A26
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 14:48:46 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id d5-v6so16277270oib.5
 for <linux-nvdimm@lists.01.org>; Mon, 18 Jun 2018 14:48:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180618213530.GB4226@vverma7-mobl4.lm.intel.com>
References: <152902249055.9927.9157713405568345680.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180618213530.GB4226@vverma7-mobl4.lm.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 18 Jun 2018 14:48:45 -0700
Message-ID: <CAPcyv4iusXi4_HjAayCU2HZsge_QL9oQaQk4K3aBbEP+XWAmeg@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: Update tests for capacity vs
 namespace-label locking
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 18, 2018 at 2:35 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> On 06/14, Dan Williams wrote:
>> Check that namespaces can be enumerated, but are disabled if the labels
>> are readable while the DIMM is locked. Alternatively, if the namespace
>> label area is locked, validate that regions with the affected DIMM fail
>> to enable.
>>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  test/Makefile.am |   10 +-
>>  test/dsm-fail.c  |  305 ++++++++++++++++++++++++++++++++++++++++++++----------
>>  2 files changed, 257 insertions(+), 58 deletions(-)
>>
>> diff --git a/test/Makefile.am b/test/Makefile.am
>> index 92cf29d6065e..f6483910af45 100644
>> --- a/test/Makefile.am
>> +++ b/test/Makefile.am
>> @@ -69,9 +69,15 @@ libndctl_LDADD = $(LIBNDCTL_LIB) $(UUID_LIBS) $(KMOD_LIBS)
>>
>>  dsm_fail_SOURCES =\
>>       dsm-fail.c \
>> -     $(testcore)
>> +     $(testcore) \
>> +     ../ndctl/namespace.c \
>> +     ../ndctl/check.c \
>> +     ../util/json.c
>>
>> -dsm_fail_LDADD = $(LIBNDCTL_LIB) $(KMOD_LIBS)
>> +dsm_fail_LDADD = $(LIBNDCTL_LIB) \
>> +             $(KMOD_LIBS) \
>> +             $(JSON_LIBS) \
>> +             ../libutil.a
>>
>>  ack_shutdown_count_set_SOURCES =\
>>       ack-shutdown-count-set.c \
>> diff --git a/test/dsm-fail.c b/test/dsm-fail.c
>> index 90d3e074f12b..b0df9da8ffab 100644
>> --- a/test/dsm-fail.c
>> +++ b/test/dsm-fail.c
>> @@ -24,6 +24,7 @@
>>
>>  #include <ccan/array_size/array_size.h>
>>  #include <ndctl/libndctl.h>
>> +#include <builtin.h>
>>  #include <ndctl.h>
>>  #include <test.h>
>>
>> @@ -38,20 +39,153 @@ static void reset_bus(struct ndctl_bus *bus)
>>       ndctl_region_foreach(bus, region)
>>               ndctl_region_disable_invalidate(region);
>>
>> -     ndctl_dimm_foreach(bus, dimm)
>> -             ndctl_dimm_zero_labels(dimm);
>> +     ndctl_dimm_foreach(bus, dimm) {
>> +             struct ndctl_cmd *cmd_read = ndctl_dimm_read_labels(dimm);
>
> This results in an unused variable warning for cmd_read. Perhaps if we
> just want tp perform the read but not do anything with the cmd struct,
> we can call it without storing the return anywhere?

Oh, whoops. If cmd_read is NULL we should fail the test. I'll spin a
new version.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
