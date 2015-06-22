Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 22 Jun 2015 18:48:37 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/15] libnvdimm: infrastructure for btt devices
Message-ID: <20150622164837.GB9393@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com> <20150622163453.GA9187@lst.de> <CAPcyv4jAA0=aSUDazG5hS1FS0o+qg4SyMXicqF_0M0s7_cXBGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jAA0=aSUDazG5hS1FS0o+qg4SyMXicqF_0M0s7_cXBGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 22, 2015 at 09:48:03AM -0700, Dan Williams wrote:
> Only if you abandon BTT on partitions, which at this point it seems
> you're boldly committed to doing.  It's unacceptable to drop BTT on
> the floor so I'll take a look at making BTT per-disk only for 4.2.

If by partitions you mean block layer partitions: yes.  If by partitions
you mean subdivision of nvdimms: no.
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Please read the FAQ at  http://www.tux.org/lkml/
