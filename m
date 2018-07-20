Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B93EA21B02845
 for <linux-nvdimm@lists.01.org>; Fri, 20 Jul 2018 08:40:06 -0700 (PDT)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4d79bd7b-c992-8259-2408-100756b9983e@intel.com>
References: <4d79bd7b-c992-8259-2408-100756b9983e@intel.com>
 <0a5ba1eb-01d2-b0f2-5e67-262fdb488bb7@intel.com>
 <153186087803.27463.7423668214880824595.stgit@djiang5-desk3.ch.intel.com>
 <153186061802.27463.14539931103401173743.stgit@djiang5-desk3.ch.intel.com>
 <9360.1531912457@warthog.procyon.org.uk>
 <19525.1531988520@warthog.procyon.org.uk>
Subject: Re: [PATCH v5 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
MIME-Version: 1.0
Content-ID: <9089.1532101203.1@warthog.procyon.org.uk>
Date: Fri, 20 Jul 2018 16:40:03 +0100
Message-ID: <9090.1532101203@warthog.procyon.org.uk>
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

> > Can you show me the whole file?
> https://lists.01.org/pipermail/linux-nvdimm/2018-July/016958.html

Is that exactly what's in your /etc/request-key.conf?

> > As I understand it, you poke an attribute file in sysfs by writing
> > "update" to it and this triggers a request_key() call.  The kernel then
> > links the key it found across to the internal keyring.
> 
> Correct. And when there isn't a key, it needs to fetch from userspace
> and construct the key.

I think I've missed a step.  Am I right in thinking that the "update" command
is just for changing the password, and is not the primary way that passwords
get into the kernel to, say, unlock the device?

> > You could instead require that the key be specified directly, ie. you
> > write "update <keyid>" to the attribute file.  The driver can then call
> > key_lookup() to get the key - or, better still, we should make
> > lookup_user_key() available so that you can call that - which will do a
> > security check.
> 
> I can attach the keyid to the nvdimm when I initially get a success key
> and the update can look it up easily enough. I'm not groking the
> lookup_user_key() comment. What determines a key to be a user key or a
> kernel key?

lookup_user_key() converts a key serial number into a key applies all the
security checks to make sure that userspace is allowed to use that key for
some purpose.

key_lookup(), on the other hand, has no security checks whatsoever.

So if you're using a key ID given to you by userspace, you have to use
lookup_user_key().  Whereas if you want to find a key by description - and
potentially create it - you use request_key().  request_key() also does all
the appropriate security checks.

So I would be tempted to make the update command take an explicit key ID
rather than calling request_key() - particularly as you want to control what
the password gets changed to.  Possibly even make it take *two* explicit key
IDs: the key holding the new password and the key holding the old one.  Then
you can have security checks on both and you can compare the descriptions to
make sure they're the same.

David
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
