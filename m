Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 919A221B02845
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 14:28:53 -0700 (PDT)
Subject: Re: [PATCH v5 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
References: <0a5ba1eb-01d2-b0f2-5e67-262fdb488bb7@intel.com>
 <153186087803.27463.7423668214880824595.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <9360.1531912457@warthog.procyon.org.uk>
 <19525.1531988520@warthog.procyon.org.uk>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <4d79bd7b-c992-8259-2408-100756b9983e@intel.com>
Date: Thu, 19 Jul 2018 14:28:34 -0700
MIME-Version: 1.0
In-Reply-To: <19525.1531988520@warthog.procyon.org.uk>
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



On 07/19/2018 01:22 AM, David Howells wrote:
> Dave Jiang <dave.jiang@intel.com> wrote:
> 
>> Ok stupid question David. I'm attempting to use the logon-type key. I
>> have added this line to the request-key.conf:
>> create   logon   nvdimm*          *      /usr/sbin/nvdimm-upcall %k
> 
> Can you show me the whole file?
https://lists.01.org/pipermail/linux-nvdimm/2018-July/016958.html

I don't believe /sbin/request-key is calling my upcall app.

> 
> Let me ask a stupid question too:  Why do you need to call request_key()?
> 
> As I understand it, you poke an attribute file in sysfs by writing "update" to
> it and this triggers a request_key() call.  The kernel then links the key it
> found across to the internal keyring.

Correct. And when there isn't a key, it needs to fetch from userspace
and construct the key.

> 
> You could instead require that the key be specified directly, ie. you write
> "update <keyid>" to the attribute file.  The driver can then call key_lookup()
> to get the key - or, better still, we should make lookup_user_key() available
> so that you can call that - which will do a security check.

I can attach the keyid to the nvdimm when I initially get a success key
and the update can look it up easily enough. I'm not groking the
lookup_user_key() comment. What determines a key to be a user key or a
kernel key?

I think right now the issue I have is trying to get logon key type
working with creating the initial key from userspace and/or update the
key with new passphrase, which needs a payload from userspace.

> 
> Another advantage of doing this is that the old key is still available in the
> internal keyring until it gets replaced.  So you can do your password change
> if you want to do it this way.
> 
> On the other hand, requiring both the old and the new passwords to be supplied
> is probably better from a security point of view, so you could require them
> both to be included in the key.
> 
> David
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
