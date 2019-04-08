Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Apr 2019 08:13:41 +1000 (AEST)
From: James Morris <jmorris@namei.org>
Subject: Re: [GIT PULL] tpmdd fixes for Linux v5.1
In-Reply-To: <CAA9_cmdyERPGwz-S3XuyJXnYrHM5V1fb_BCf_NS_kgQdN-YS=A@mail.gmail.com>
Message-ID: <alpine.LRH.2.21.1904090813230.18801@namei.org>
References: <20190329115544.GA27351@linux.intel.com> <alpine.LRH.2.21.1903300540530.2240@namei.org> <CAA9_cmdyERPGwz-S3XuyJXnYrHM5V1fb_BCf_NS_kgQdN-YS=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 8 Apr 2019, Dan Williams wrote:

> On Fri, Mar 29, 2019 at 11:42 AM James Morris <jmorris@namei.org> wrote:
> >
> > On Fri, 29 Mar 2019, Jarkko Sakkinen wrote:
> >
> > > Hi James,
> > >
> > > These are critical fixes for v5.1. Contains also couple of new selftests for
> > > v5.1 features (partial reads in /dev/tpm0). I hope these could still reach
> > > the release. Thanks.
> >
> > Applied to
> > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git next-tpm
> 
> Hi James,
> 
> Friendly ping on when might this go to Linus?
> 
> I was hoping that 3d0b1a381f6e ("KEYS: trusted: allow trusted.ko to
> initialize w/o a TPM") would have hit -rc4. The NVDIMM subsystem has
> been broken since -rc1.

Oops, I queued these for the wrong tree, will send to Linus today.

-- 
James Morris
<jmorris@namei.org>
