Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Tue, 23 Jun 2015 12:20:08 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/15] libnvdimm: infrastructure for btt devices
Message-ID: <20150623102008.GH24894@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com> <20150622163453.GA9187@lst.de> <CAPcyv4jAA0=aSUDazG5hS1FS0o+qg4SyMXicqF_0M0s7_cXBGw@mail.gmail.com> <20150622164837.GB9393@lst.de> <x49k2uvvbje.fsf@segfault.boston.devel.redhat.com> <CAPcyv4hSAPTRNLkfKGndUrxjzTp-FAW+4G8t926YZdVH2c-Q=g@mail.gmail.com> <x49bng7v9v5.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49bng7v9v5.fsf@segfault.boston.devel.redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 03:09:02PM -0400, Jeff Moyer wrote:
> The xfs example is enough to convince me that we need to support btt on
> a partition right now.  Otherwise, for RHEL at least, dax on xfs simply
> won't be supported.

Seems like an odd stance to support some new code coming out of the
blue in favor of something developed by RH for years and already shipping
as the default filesystem at the major competitor..
