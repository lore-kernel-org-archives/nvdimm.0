Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 920BB21BADAB2
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 15:29:25 -0700 (PDT)
Subject: Re: [PATCH v6 05/11] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
References: <153255233932.51274.17371670672074459834.stgit@djiang5-desk3.ch.intel.com>
 <153255001863.51274.11308713958786222873.stgit@djiang5-desk3.ch.intel.com>
 <20101.1533211253@warthog.procyon.org.uk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <465ca753-ad2c-6888-b139-8cb9c4472290@intel.com>
Date: Thu, 2 Aug 2018 15:29:22 -0700
MIME-Version: 1.0
In-Reply-To: <20101.1533211253@warthog.procyon.org.uk>
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



On 08/02/2018 05:00 AM, David Howells wrote:
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> +	/* request new key from userspace */
>> +	key = nvdimm_request_key(dev, update);
>> +	if (!key) {
>> +		dev_dbg(dev, "%s: failed to acquire new key\n", __func__);
>> +		rc = -ENXIO;
>> +		goto out;
>> +	}
> 
> I still think you're better taking two explicit key IDs as part of the command
> rather than using request_key() to *hopefully* pick the right target.

In order to do this, I would need to do a key_add() in userspace to add
a new key with the new payload before I can initiate update correct? So
for an update it would look something like:
1. (user) add key with new payload
2. (user) lookup old key
3. (user) write to sysfs update attrib: "update:<old id>:<new id>"
4. (kernel) check old_id against cached key and make sure they match
5. (kernel) check new key desc against old key and make sure they match
6. (kernel) update to hardware
6. (kernel) when success, link the new key to the kernel keyring and
it'll replace the old key?


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
