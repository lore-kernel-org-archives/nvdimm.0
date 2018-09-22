Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69D292112999C
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 18:26:28 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id e18-v6so14767641oti.8
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 18:26:28 -0700 (PDT)
MIME-Version: 1.0
References: <153549647177.4089.18112512093259339717.stgit@djiang5-desk3.ch.intel.com>
 <153549632073.4089.3609134467249378610.stgit@djiang5-desk3.ch.intel.com>
 <19459.1537574236@warthog.procyon.org.uk>
 <c804ec81-68c5-3e11-c65f-1226e68a4b2b@intel.com>
In-Reply-To: <c804ec81-68c5-3e11-c65f-1226e68a4b2b@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Sep 2018 18:26:16 -0700
Message-ID: <CAPcyv4gVoN2orHRFie-Q=hBRva1UCds-g=nHAT6zqEZ8YBh3uQ@mail.gmail.com>
Subject: Re: [PATCH v8 06/12] nfit/libnvdimm: add set passphrase support for
 Intel nvdimms
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
Cc: "Schofield, Alison" <alison.schofield@intel.com>, Kees Cook <keescook@chromium.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Eric Biggers <ebiggers3@gmail.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 21, 2018 at 5:29 PM Dave Jiang <dave.jiang@intel.com> wrote:
[..]
> > What I meant here was to use, say, nvdimm_lookup_user_key() to get a key from
> > userspace that contains the old password.  You can use the description of the
> > key to search nvdimm_keyring for the private key and then compare the
> > passwords.
>
> Ok I have a bit of confusion here. When the user injects a new key with
> the same description and new passphrase, would that not replace the
> existing user key with the old passphrase? Also, if I'm calling
> lookup_user_key, where would the key_id come from for the old user key?
> I suppose I can cache it.... Maybe I'm not quite understanding the exact
> flow of how things you are suggesting.

If the DIMM is in the in the unlocked state the kernel should already
have the old passphrase cached, right? Could we just have the kernel
fail ->change_key() requests if the kernel does not already have a
valid old passphrase?

It does mean we can't support going from the locked state directly to
changing the password, but I would expect requiring an initial unlock
is fine.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
