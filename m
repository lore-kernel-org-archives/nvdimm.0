Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3A5F2211E2C0A
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 06:48:40 -0700 (PDT)
Date: Thu, 21 Mar 2019 15:48:31 +0200
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [PATCH 0/6] security/keys/encrypted: Break module dependency chain
Message-ID: <20190321134831.GC4603@linux.intel.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ij2nHD7JumKNcNYB4gAGujWzCPkcpoi=XafmG3EP2b0g@mail.gmail.com>
 <20190321134549.GB4603@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190321134549.GB4603@linux.intel.com>
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
Cc: David Howells <dhowells@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, James Bottomley <jejb@linux.ibm.com>, ecryptfs@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, Tyler Hicks <tyhicks@canonical.com>, keyrings@vger.kernel.org, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 03:45:49PM +0200, Jarkko Sakkinen wrote:
> On Tue, Mar 19, 2019 at 02:01:44PM -0700, Dan Williams wrote:
> > On Mon, Mar 18, 2019 at 11:18 PM Dan Williams <dan.j.williams@intel.com> wrote:
> > >
> > > With v5.1-rc1 all the nvdimm sub-system regression tests started failing
> > > because the libnvdimm module failed to load in the qemu-kvm test
> > > environment.  Critically that environment does not have a TPM. Commit
> > > 240730437deb "KEYS: trusted: explicitly use tpm_chip structure..."
> > > started to require a TPM to be present for the trusted.ko module to load
> > > where there was no requirement for that before.
> > >
> > > Rather than undo the "fail if no hardware" behavior James points out
> > > that the module dependencies can be broken by looking up the key-type by
> > > name. Remove the dependencies on the "key_type_trusted" and
> > > "key_type_encrypted" symbol exports, and clean up other boilerplate that
> > > supported those exports in different configurations.
> > 
> > Any feedback? Was hoping to get at least patch1 in the queue for
> > v5.1-rc2 since this effectively disables the nvdimm driver on typical
> > configurations. Jarkko, would you be willing to merge it since the
> > regression came through your tree?
> 
> Yes, of course. The feedback has been extremely passive because I've
> been sick leave for the early week :-)
> 
> Before I'm merging this I'm just thinking that would it be better
> idea to merge a patch for trusted.c that reverts the old behavior
> with cc to stable and fixes tags as I said in my earlier response.
> 
> It would less intrusive for stable kernels. Lets quickly sort out
> the best strategy before merging.

I.e. the way I see the situation:

1. Reverting the old behavior in the sense that missing TPM does
   not prevent init of trusted.ko should be done right now.
2. Your patch could be definitely merged but not as a bug fix.
3. At some point we could consider failing the init of trusted.ko
   if TPM is missing because that is kind of senseful anyway with
   better testing now that we understand the dependency context
   better.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
