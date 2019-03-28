Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7BE31211E82F6
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 12:17:43 -0700 (PDT)
Subject: Re: [PATCH 1/3] ndctl: fix load-keys for user master-key
References: <155380002962.7924.11109542476291499729.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4j0jKPiYR7LFQzwbMZkieFn1G-7bJz85MUDcrf8BsSC0g@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <73b19eaf-ace5-632c-33a6-0db018ebe05e@intel.com>
Date: Thu, 28 Mar 2019 12:17:30 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j0jKPiYR7LFQzwbMZkieFn1G-7bJz85MUDcrf8BsSC0g@mail.gmail.com>
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



On 3/28/19 12:11 PM, Dan Williams wrote:
> On Thu, Mar 28, 2019 at 12:07 PM Dave Jiang <dave.jiang@intel.com> wrote:
>>
>> load-keys incorrectly assumes that all keys have TPM handles. TPM handle is
>> only for trusted-keys. Fix in order to allow user master-key work.
> 
> s/work/to operate/ ?
> 
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  ndctl/load-keys.c |    6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
>> index 8e4998f2..19380152 100644
>> --- a/ndctl/load-keys.c
>> +++ b/ndctl/load-keys.c
>> @@ -213,10 +213,8 @@ static int load_keys(struct loadkeys *lk_ctx, const char *keypath,
>>
>>         if (!tpmhandle) {
>>                 rc = check_tpm_handle(lk_ctx);
>> -               if (rc < 0) {
>> -                       rc = -errno;
>> -                       goto erropen;
>> -               }
>> +               if (rc < 0)
>> +                       printf("No TPM handle discovered.\n");
> 
> Please keep error messages on stderr.

Actually this is info. At this point we do not have context as to if a
trusted key or user key being loaded, and it could be we are using user
master key or it could be TPM handle can't be found.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
