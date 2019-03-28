Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69380211EB812
 for <linux-nvdimm@lists.01.org>; Thu, 28 Mar 2019 12:30:09 -0700 (PDT)
Subject: Re: [PATCH 2/3] ndctl: fix key blob loading for user keys
References: <155380002962.7924.11109542476291499729.stgit@djiang5-desk3.ch.intel.com>
 <155380003495.7924.1527087606331560941.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4gLVVC26VjYqsAyGG6Cm62+=xuKWvu5REw4iXtXWyc_nw@mail.gmail.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <0d034ac5-b352-af45-3de1-0289e5d50ecc@intel.com>
Date: Thu, 28 Mar 2019 12:30:03 -0700
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gLVVC26VjYqsAyGG6Cm62+=xuKWvu5REw4iXtXWyc_nw@mail.gmail.com>
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



On 3/28/19 12:18 PM, Dan Williams wrote:
> On Thu, Mar 28, 2019 at 12:07 PM Dave Jiang <dave.jiang@intel.com> wrote:
>>
>> The syntax for loading user master key is different than loading a trusted
>> key. Fix so we can load user key properly.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  ndctl/load-keys.c |   13 +++++--------
>>  ndctl/util/keys.c |   20 +++++++++++++++-----
>>  ndctl/util/keys.h |   10 ++++++++--
>>  3 files changed, 28 insertions(+), 15 deletions(-)
>>
>> diff --git a/ndctl/load-keys.c b/ndctl/load-keys.c
>> index 19380152..c0d0d743 100644
>> --- a/ndctl/load-keys.c
>> +++ b/ndctl/load-keys.c
>> @@ -25,12 +25,7 @@ static struct parameters {
>>         const char *tpm_handle;
>>  } param;
>>
>> -enum key_type {
>> -       KEY_USER = 0,
>> -       KEY_TRUSTED,
>> -};
>> -
>> -static const char *key_names[] = {"user", "trusted"};
>> +static const char *key_names[] = {"user", "trusted", "encrypted"};
>>
>>  static struct loadkeys {
>>         enum key_type key_type;
>> @@ -44,6 +39,7 @@ static int load_master_key(struct loadkeys *lk_ctx, const char *keypath)
>>         char *blob;
>>         int size, rc;
>>         char path[PATH_MAX];
>> +       enum key_type;
>>
>>         rc = sprintf(path, "%s/nvdimm-master.blob", keypath);
>>         if (rc < 0)
>> @@ -65,7 +61,8 @@ static int load_master_key(struct loadkeys *lk_ctx, const char *keypath)
>>                 return -errno;
>>         }
>>
>> -       blob = ndctl_load_key_blob(path, &size, param.tpm_handle, -1);
>> +       blob = ndctl_load_key_blob(path, &size, param.tpm_handle, -1,
>> +                       lk_ctx->key_type);
> 
> Where is  lk_ctx->key_type set? I don't think I see any assignments in
> this patch.
> 

In ndctl/load-keys.c:load_master_key() previously. It's not new.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
