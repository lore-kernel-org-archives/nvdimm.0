Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 24 Jun 2015 14:10:40 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/15] libnvdimm: infrastructure for btt devices
Message-ID: <20150624121040.GB17542@lst.de>
References: <20150617235209.12943.24419.stgit@dwillia2-desk3.amr.corp.intel.com> <20150617235458.12943.23425.stgit@dwillia2-desk3.amr.corp.intel.com> <20150622163453.GA9187@lst.de> <CAPcyv4jAA0=aSUDazG5hS1FS0o+qg4SyMXicqF_0M0s7_cXBGw@mail.gmail.com> <20150622164837.GB9393@lst.de> <x49k2uvvbje.fsf@segfault.boston.devel.redhat.com> <CAPcyv4hSAPTRNLkfKGndUrxjzTp-FAW+4G8t926YZdVH2c-Q=g@mail.gmail.com> <20150623101917.GG24894@lst.de> <CAPcyv4i8ciusz34UArM5MFFB8V-dz2JrCGKgkT3i5d6QT0-0xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4i8ciusz34UArM5MFFB8V-dz2JrCGKgkT3i5d6QT0-0xA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 23, 2015 at 08:19:57AM -0700, Dan Williams wrote:
> That tie was only to enable autodetect so that we don't need to run a
> BTT assembly step from an initramfs just to get an NVDIMM up and
> running.  It was a convenience, not a requirement.

It's a very deep tying for that feature.  Look at what the raid code
does just for scanning.  Although even that is officially deprecate
because people don't like in-kernel scanning (which I tend to disagree with).
