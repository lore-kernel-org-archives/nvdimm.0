Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0BE6B21BADAB2
 for <linux-nvdimm@lists.01.org>; Wed, 18 Jul 2018 12:41:04 -0700 (PDT)
Subject: Re: [PATCH v5 02/12] libnvdimm: create keyring to store security keys
References: <153186085546.27463.5501870662513432986.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <7121.1531911057@warthog.procyon.org.uk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <a3bce7ee-96b0-bafc-3194-52b4fcc08f84@intel.com>
Date: Wed, 18 Jul 2018 12:40:48 -0700
MIME-Version: 1.0
In-Reply-To: <7121.1531911057@warthog.procyon.org.uk>
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
Cc: linux-nvdimm@lists.01.org, keyrings@vger.kernel.org, alison.schofield@intel.com, keescook@chromium.org
List-ID: <linux-nvdimm@lists.01.org>



On 07/18/2018 03:50 AM, David Howells wrote:
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> +static int nvdimm_key_instantiate(struct key *key,
>> +		struct key_preparsed_payload *prep)
> 
> Please use ->preparse() if you can rather than doing this in ->instantiate().
> Ideally ->instantiate() should not return an error, particularly not -EINVAL
> or -ENOMEM.
> 
>> +{
>> +	char *payload;
>> +
>> +	payload = kzalloc(nvdimm_key_type.def_datalen, GFP_KERNEL);
>> +	if (!payload)
>> +		return -ENOMEM;
> 
> Ummm...  Why not just kmemdup()?  Why not use use prep->datalen here rather
> than def_datalen?
> 
>> +
>> +	key->datalen = min(nvdimm_key_type.def_datalen, prep->datalen);
>> +	memcpy(payload, prep->data, key->datalen);
>> +	key->payload.data[0] = payload;
>> +	return 0;
>> +}
> 
> I would recommend, firstly, that you use generic_key_instantiate() if you can;
> if not, you might want to use rcu_assign_keypointer().
> 
>> +	cred = prepare_kernel_cred(NULL);
>> +	if (!cred) {
>> +		rc = -ENOMEM;
>> +		goto failed_cred;
>> +	}
> 
> I wonder if you could just use &init_cred instead.

You mean also instead of a dedicated keyring, just use the existing ones
that comes with init_cred as well?

> 
> David
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
