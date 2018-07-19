Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C44EB21B02845
 for <linux-nvdimm@lists.01.org>; Thu, 19 Jul 2018 01:22:03 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <0a5ba1eb-01d2-b0f2-5e67-262fdb488bb7@intel.com>
References: <0a5ba1eb-01d2-b0f2-5e67-262fdb488bb7@intel.com>
 <153186087803.27463.7423668214880824595.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <9360.1531912457@warthog.procyon.org.uk>
Subject: Re: [PATCH v5 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <19524.1531988520.1@warthog.procyon.org.uk>
Date: Thu, 19 Jul 2018 09:22:00 +0100
Message-ID: <19525.1531988520@warthog.procyon.org.uk>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: alison.schofield@intel.com, keescook@chromium.org, linux-nvdimm@lists.01.org, dhowells@redhat.com, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Dave Jiang <dave.jiang@intel.com> wrote:

> Ok stupid question David. I'm attempting to use the logon-type key. I
> have added this line to the request-key.conf:
> create   logon   nvdimm*          *      /usr/sbin/nvdimm-upcall %k

Can you show me the whole file?

Let me ask a stupid question too:  Why do you need to call request_key()?

As I understand it, you poke an attribute file in sysfs by writing "update" to
it and this triggers a request_key() call.  The kernel then links the key it
found across to the internal keyring.

You could instead require that the key be specified directly, ie. you write
"update <keyid>" to the attribute file.  The driver can then call key_lookup()
to get the key - or, better still, we should make lookup_user_key() available
so that you can call that - which will do a security check.

Another advantage of doing this is that the old key is still available in the
internal keyring until it gets replaced.  So you can do your password change
if you want to do it this way.

On the other hand, requiring both the old and the new passwords to be supplied
is probably better from a security point of view, so you could require them
both to be included in the key.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
