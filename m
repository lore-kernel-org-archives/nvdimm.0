Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1A62211DC089
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 16:02:03 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id t206so306277oib.3
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 16:02:03 -0700 (PDT)
MIME-Version: 1.0
References: <155295271345.1945351.6465460744078693578.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1552955080.2785.26.camel@linux.ibm.com>
 <CAA9_cmcOD2zPaaNbkYAaH5DRDRAebPkW+hwPA0zPKY4kU8R-rg@mail.gmail.com>
 <1553036189.4899.136.camel@linux.ibm.com>
In-Reply-To: <1553036189.4899.136.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Mar 2019 16:01:51 -0700
Message-ID: <CAPcyv4j+4WMFsEbT_TDQfNs2ZG6+ME6b07RaqmT9kfbTStWgJQ@mail.gmail.com>
Subject: Re: [PATCH] security/keys/trusted: Allow operation without hardware
 TPM
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
To: Mimi Zohar <zohar@linux.ibm.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, James Bottomley <jejb@linux.ibm.com>, Roberto Sassu <roberto.sassu@huawei.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 19, 2019 at 3:56 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
>
> Hi Dan,
>
> On Mon, 2019-03-18 at 17:30 -0700, Dan Williams wrote:
>
> Sorry for the late reply.
>
> > On Mon, Mar 18, 2019 at 5:24 PM James Bottomley <jejb@linux.ibm.com> wrote:
> > >
> > > On Mon, 2019-03-18 at 16:45 -0700, Dan Williams wrote:
> > > > Rather than fail initialization of the trusted.ko module, arrange for
> > > > the module to load, but rely on trusted_instantiate() to fail
> > > > trusted-key operations.
> > >
> > > What actual problem is this fixing?  To me it would seem like an
> > > enhancement to make the trusted module fail at load time if there's no
> > > TPM rather than waiting until first use to find out it can never work.
> > > Is there some piece of user code that depends on the successful
> > > insertion of trusted.ko?
> >
> > The module dependency chain relies on it. If that can be broken that
> > would also be an acceptable fix.
> >
> > I found this through the following dependency chain: libnvdimm.ko ->
> > encrypted_keys.ko -> trusted.ko.
> >
> > "key_type_trusted" is the symbol that encrypted_keys needs regardless
> > of whether the tpm is present.
>
> Commit 982e617a313b ("encrypted-keys: remove trusted-keys dependency")
> removed the dependency on trusted keys.  masterkey_trusted.c should
> only be included if "CONFIG_TRUSTED_KEYS" is enabled.  Is
> CONFIG_TRUSTED_KEYS enabled?

Yes, TRUSTED_KEYS is enabled, the module is built/available, and tries
to load when encrypted_keys.ko loads. The problem is that it fails to
load due an error returned from init_trusted(). The error is new for
v5.1. So, instead of requiring the module dependencies to resolve
successfully, and init_trusted() to return 0, the proposal is to just
lookup the key types by name.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
