Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E52E42115471B
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 16:27:20 -0700 (PDT)
Subject: Re: [PATCH v8 05/12] nfit/libnvdimm: add unlock of nvdimm support for
 Intel DIMMs
References: <153549646600.4089.2626014553500613547.stgit@djiang5-desk3.ch.intel.com>
 <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
 <17433.1537572050@warthog.procyon.org.uk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <58be84f5-c36c-1868-8bd3-06a09d6b59c6@intel.com>
Date: Fri, 21 Sep 2018 16:27:18 -0700
MIME-Version: 1.0
In-Reply-To: <17433.1537572050@warthog.procyon.org.uk>
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
To: David Howells <dhowells@redhat.com>
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, ebiggers3@gmail.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 09/21/2018 04:20 PM, David Howells wrote:
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> +	depends on KEYS
> 
> That needs to be in patch 2 where you create a keyring.
> 
>> +	char desc[NVDIMM_KEY_DESC_LEN + strlen(NVDIMM_PREFIX)];
> 
> You should be using sizeof() not strlen() and do you need + 1 for the NUL
> char?
> 
>> +	sprintf(desc, "%s%s", NVDIMM_PREFIX, nvdimm->dimm_id);
> 
> NVDIMM_PREFIX is a constant string.  I would recommend either declaring it as
> a const char[] or just sticking it in the format string in place of the %s:
> 
> 	sprintf(desc, NVDIMM_PREFIX "%s", nvdimm->dimm_id);
> 
>> +		if (!cached_key) {
>> +			key_link(nvdimm_keyring, key);
>> +			nvdimm->key = key;
>> +			key->perm |= KEY_USR_SEARCH;
>> +		}
> 
> Ummm...  You're altering the key permission?  That's not really yours to
> change.

What can I do to allow the user app to look up the right key in order to
pass the key id to sysfs? Without the KEY_USR_SEARCH I am not able to
search for that key in the keyring.

> 
>> +static int nvdimm_check_key_len(unsigned short len, bool update)
>> +{
>> +	if (len == (NVDIMM_PASSPHRASE_LEN * 2) && update)
>> +		return 0;
> 
> In the cover you said:
> 
> 	- Modified "update" to take two key ids and and use lookup_user_key()
> 	  in order to improve security.  (David)
> 
> is this a holdover?

No. We are passing in two key ids to sysfs. The new one and the existing
one. I think that was what you suggested to do. With the above issue,
should I only just pass in the new key id since the specific sysfs node
should know which key to update already?


> 
> David
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
