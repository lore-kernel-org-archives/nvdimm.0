Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 205932034C8AB
 for <linux-nvdimm@lists.01.org>; Fri, 27 Apr 2018 12:50:29 -0700 (PDT)
Subject: Re: [PATCH v4 2/4] ndctl: convert namespace actions to use
 util_filter_walk()
References: <152485300486.47995.7487206758776476576.stgit@djiang5-desk3.ch.intel.com>
 <152485312055.47995.12642343910789705739.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4g240gwbHX4-JJUNeuzVy0T4Dz5Ykh=SQf7JyAuWCf5qA@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <18929fa3-4a92-cfb0-a63f-561c76689ff1@intel.com>
Date: Fri, 27 Apr 2018 12:50:28 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g240gwbHX4-JJUNeuzVy0T4Dz5Ykh=SQf7JyAuWCf5qA@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 04/27/2018 12:25 PM, Dan Williams wrote:
> On Fri, Apr 27, 2018 at 11:18 AM, Dave Jiang <dave.jiang@intel.com> wrote:
>> util_filter_walk() does the looping through of busses and regions. Removing
>> duplicate code in namespace ops and provide filter functions so we can
>> utilize util_filter_walk() and share common code.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  ndctl/namespace.c |  164 ++++++++++++++++++++++++++++++-----------------------
>>  test/btt-check.sh |    2 -
>>  util/filter.c     |    5 +-
>>  util/filter.h     |    8 +++
>>  4 files changed, 105 insertions(+), 74 deletions(-)
>>
>> diff --git a/ndctl/namespace.c b/ndctl/namespace.c
>> index e61f500c..404d6761 100644
>> --- a/ndctl/namespace.c
>> +++ b/ndctl/namespace.c
>> @@ -983,14 +983,92 @@ static int namespace_reconfig(struct ndctl_region *region,
>>  int namespace_check(struct ndctl_namespace *ndns, bool verbose, bool force,
>>                 bool repair, bool logfix);
>>
>> +static bool filter_bus(struct ndctl_bus *bus, struct util_filter_ctx *ctx)
>> +{
>> +       return true;
>> +}
>> +
>> +static bool filter_region(struct ndctl_region *region,
>> +               struct util_filter_ctx *ctx)
>> +{
>> +       struct nsaction_filter_arg *nfa = ctx->nsaction;
>> +       int rc = 0;
>> +       bool out = true;
>> +
>> +       if (nfa->action == ACTION_CREATE && !nfa->namespace) {
>> +               if (nfa->rc == 1)
>> +                       return false;
>> +
>> +               rc = namespace_create(region);
>> +               if (rc != -EAGAIN) {
>> +                       if (rc == 0)
>> +                               rc = 1;
>> +                       /* don't proceed in the filter loop */
>> +                       out = false;
>> +               }
>> +               nfa->rc = rc;
>> +       }
>> +
>> +       return out;
>> +}
>> +
>> +static void filter_namespace(struct ndctl_namespace *ndns,
>> +               struct util_filter_ctx *ctx)
>> +{
>> +       struct ndctl_region *region = ndctl_namespace_get_region(ndns);
>> +       struct nsaction_filter_arg *nfa = ctx->nsaction;
>> +       const char *ndns_name;
>> +       int rc;
>> +
>> +       /* we have an error, don't do anything else */
>> +       if (nfa->rc < 0)
>> +               return;
> 
> Why do we need to stop here? This seems like a behavior regression.
> 
> For example:
> 
>     ndctl disable-namespace all
> 
> Should continue to disable subsequent namespaces even if a previous
> namespace attempt fails.
> 

Yes I misread the original flow. I need to replace that with:

if (!nfa->namespace)
	return;


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
