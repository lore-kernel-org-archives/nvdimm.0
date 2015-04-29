Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALCETrWcH76_P8pzK+cur50pk--VppkjG9z3ueXMAS_=x9jd1w@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150428182514.35812.12126.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CALCETrVLoJj6f72MraEZ3dUA9Mgr8fK17Yw-ACT7pvfB9nZ4MA@mail.gmail.com>
	<CAAek22GZPnBnHcPnNHe-dfNb9Kd_TNDHGXYMpdYRNQtNr4FnFw@mail.gmail.com>
	<CALCETrWcH76_P8pzK+cur50pk--VppkjG9z3ueXMAS_=x9jd1w@mail.gmail.com>
Date: Wed, 29 Apr 2015 08:55:00 -0700
Message-ID: <CAPcyv4j1q42XM=ChhKXti6qcQBgm-zggF5mHH4zEKjKxtZxJWQ@mail.gmail.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 11/20] libnd, nd_pmem: add libnd support
 to the pmem driver
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Phil Pokorny <ppokorny@penguincomputing.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 3:58 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Apr 28, 2015 at 3:21 PM, Phil Pokorny
> <ppokorny@penguincomputing.com> wrote:
>> On Tue, Apr 28, 2015 at 2:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>>> On Tue, Apr 28, 2015 at 11:25 AM, Dan Williams <dan.j.williams@intel.com> wrote:
[..]
> This is such a mess that I think this driver should maybe flat-out
> refuse to load in this type of configuration without some scary module
> option.  I have some NVDIMMs that report as type 12 but need two extra
> out-of-tree drivers to work safely.  First, they need i2c_imc or the
> equivalent (I'll try to resubmit that soon).  Second, they need secret
> magic NDAed register poking.  The latter is very problematic.
>
> At the very least, I think we should discourage people who don't
> really know what they're doing from using this driver without care.

The benefit of the type-12 experiment having not made it very far out
of the lab is that it may be feasible to whitelist known platforms
where we believe ADR is available.  Otherwise, the presence of the
NFIT asserts platform persistent memory support.
