Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:34:18 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 05/21] libnvdimm: control (ioctl) messages for
	libnvdimm bus and dimm devices
Message-ID: <20150609063418.GB9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001435.4506.42614.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150602001435.4506.42614.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 01, 2015 at 08:14:35PM -0400, Dan Williams wrote:
> Most discovery/configuration of the libnvdimm-subsystem is done via
> sysfs attributes.  However, some libnvdimm buses, particularly the
> ACPI.NFIT bus, define a small set of messages that can be passed to the
> platform.  For convenience we derive the initial libnvdimm-ioctl command
> formats directly from the NFIT DSM Interface Example formats.

Why not merge these into the extensive sysfs interface?
