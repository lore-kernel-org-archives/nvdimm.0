Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A040721962301
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 18:11:11 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id
 x2K18koH045189
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 21:11:10 -0400
Received: from e06smtp04.uk.ibm.com (e06smtp04.uk.ibm.com [195.75.94.100])
 by mx0a-001b2d01.pphosted.com with ESMTP id 2rb8q7edtu-1
 (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Tue, 19 Mar 2019 21:11:10 -0400
Received: from localhost
 by e06smtp04.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <zohar@linux.ibm.com>;
 Wed, 20 Mar 2019 01:11:02 -0000
Subject: Re: [PATCH 2/6] security/keys/encrypted: Clean up
 request_trusted_key()
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Tue, 19 Mar 2019 21:10:52 -0400
In-Reply-To: <CAPcyv4heLwdJR+xKZfvx5TAvqsKr3sNCda_ovivguLKbiXhyYg@mail.gmail.com>
References: <155297557534.2276575.16264199708584900090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155297558570.2276575.11731393787282486177.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1553040398.4899.149.camel@linux.ibm.com>
 <CAPcyv4heLwdJR+xKZfvx5TAvqsKr3sNCda_ovivguLKbiXhyYg@mail.gmail.com>
Mime-Version: 1.0
Message-Id: <1553044252.4899.165.camel@linux.ibm.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, James Bottomley <jejb@linux.ibm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2019-03-19 at 17:20 -0700, Dan Williams wrote:
> On Tue, Mar 19, 2019 at 5:07 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > On Mon, 2019-03-18 at 23:06 -0700, Dan Williams wrote:
> 
> > > diff --git a/security/keys/key.c b/security/keys/key.c
> > > index 696f1c092c50..9045b62afb04 100644
> > > --- a/security/keys/key.c
> > > +++ b/security/keys/key.c
> > > @@ -706,6 +706,7 @@ struct key_type *key_type_lookup(const char *type)
> > >  found_kernel_type:
> > >       return ktype;
> > >  }
> > > +EXPORT_SYMBOL_GPL(key_type_lookup);
> 
> This needs to be moved to patch1.
> 
> > Only the kernel is calling key_type_lookup().  Why does
> > key_type_lookup() need to be exported?
> 
> This patch series adds several new callers outside of keys-subsystem
> core that need this export, the first one being encrypted-keys itself
> in patch1.

It's needed, because they could be compiled as kernel modules, not
builtin (eg. EVM).

Mimi

> 
> drivers/nvdimm/security.c:57:   type = key_type_lookup("encrypted");
> fs/ecryptfs/keystore.c:1627:    type = key_type_lookup("encrypted");
> security/integrity/evm/evm_crypto.c:361:        type =
> key_type_lookup("encrypted");
> security/keys/encrypted-keys/encrypted.c:440:   type =
> key_type_lookup("trusted");
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
