Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9BE5021A07093
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 14:23:24 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id h7so208797otm.2
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 14:23:24 -0700 (PDT)
MIME-Version: 1.0
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ij2nHD7JumKNcNYB4gAGujWzCPkcpoi=XafmG3EP2b0g@mail.gmail.com>
 <1553029714.2932.43.camel@linux.ibm.com>
In-Reply-To: <1553029714.2932.43.camel@linux.ibm.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Mar 2019 14:23:13 -0700
Message-ID: <CAPcyv4jt-wbjR-eyeJ=hrcAF2jGBw11tdwL9=33+-CfxNNgLjg@mail.gmail.com>
Subject: Re: [PATCH 0/6] security/keys/encrypted: Break module dependency chain
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
To: James Bottomley <jejb@linux.ibm.com>
Cc: David Howells <dhowells@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, ecryptfs@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Tyler Hicks <tyhicks@canonical.com>, keyrings@vger.kernel.org, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 19, 2019 at 2:09 PM James Bottomley <jejb@linux.ibm.com> wrote:
>
> On Tue, 2019-03-19 at 14:01 -0700, Dan Williams wrote:
> > On Mon, Mar 18, 2019 at 11:18 PM Dan Williams <dan.j.williams@intel.c
> > om> wrote:
> > >
> > > With v5.1-rc1 all the nvdimm sub-system regression tests started
> > > failing because the libnvdimm module failed to load in the qemu-kvm
> > > test environment.  Critically that environment does not have a TPM.
> > > Commit 240730437deb "KEYS: trusted: explicitly use tpm_chip
> > > structure..." started to require a TPM to be present for the
> > > trusted.ko module to load where there was no requirement for that
> > > before.
> > >
> > > Rather than undo the "fail if no hardware" behavior James points
> > > out that the module dependencies can be broken by looking up the
> > > key-type by name. Remove the dependencies on the "key_type_trusted"
> > > and "key_type_encrypted" symbol exports, and clean up other
> > > boilerplate that supported those exports in different
> > > configurations.
> >
> > Any feedback? Was hoping to get at least patch1 in the queue for
> > v5.1-rc2 since this effectively disables the nvdimm driver on typical
> > configurations. Jarkko, would you be willing to merge it since the
> > regression came through your tree?
>
> The reason I sent out the RFC was to see if the people who actually
> wrote the code had any reasons they needed the current way of doing
> things preserving.
>
> I think your series looks fine except you need to export
> key_type_lookup (patch 2) before you use it (patch 1) to preserve
> bisectability of builds.

Good catch, I fumbled that around. I'll respin and let 0day chew on it
before sending out another version.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
