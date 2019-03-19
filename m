Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C43921A07A82
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 14:08:49 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x2JL0Mou148662
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 17:08:48 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
 by mx0b-001b2d01.pphosted.com with ESMTP id 2rb520g9vc-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 17:08:45 -0400
Received: from localhost
 by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <jejb@linux.ibm.com>;
 Tue, 19 Mar 2019 21:08:48 -0000
Subject: Re: [PATCH 0/6] security/keys/encrypted: Break module dependency chain
From: James Bottomley <jejb@linux.ibm.com>
Date: Tue, 19 Mar 2019 14:08:34 -0700
In-Reply-To: <CAPcyv4ij2nHD7JumKNcNYB4gAGujWzCPkcpoi=XafmG3EP2b0g@mail.gmail.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CAPcyv4ij2nHD7JumKNcNYB4gAGujWzCPkcpoi=XafmG3EP2b0g@mail.gmail.com>
Mime-Version: 1.0
Message-Id: <1553029714.2932.43.camel@linux.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, keyrings@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, ecryptfs@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Tyler Hicks <tyhicks@canonical.com>, Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2019-03-19 at 14:01 -0700, Dan Williams wrote:
> On Mon, Mar 18, 2019 at 11:18 PM Dan Williams <dan.j.williams@intel.c
> om> wrote:
> > 
> > With v5.1-rc1 all the nvdimm sub-system regression tests started
> > failing because the libnvdimm module failed to load in the qemu-kvm 
> > test environment.  Critically that environment does not have a TPM.
> > Commit 240730437deb "KEYS: trusted: explicitly use tpm_chip
> > structure..." started to require a TPM to be present for the
> > trusted.ko module to load where there was no requirement for that
> > before.
> > 
> > Rather than undo the "fail if no hardware" behavior James points
> > out that the module dependencies can be broken by looking up the
> > key-type by name. Remove the dependencies on the "key_type_trusted"
> > and "key_type_encrypted" symbol exports, and clean up other
> > boilerplate that supported those exports in different
> > configurations.
> 
> Any feedback? Was hoping to get at least patch1 in the queue for
> v5.1-rc2 since this effectively disables the nvdimm driver on typical
> configurations. Jarkko, would you be willing to merge it since the
> regression came through your tree?

The reason I sent out the RFC was to see if the people who actually
wrote the code had any reasons they needed the current way of doing
things preserving.

I think your series looks fine except you need to export
key_type_lookup (patch 2) before you use it (patch 1) to preserve
bisectability of builds.

James

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
