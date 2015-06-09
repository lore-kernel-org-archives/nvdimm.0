Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:48:11 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 20/21] tools/testing/nvdimm: manufactured NFITs for
	interface development
Message-ID: <20150609064811.GG9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001557.4506.57136.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150602001557.4506.57136.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The description fails to mention the hacks how this is archived.  I don't
think the include hackery and otherwise needed exports are acceptable
if with an explanation, though.

Really - get your fake hardware into qemu right now and don't bother
with trying to hack the subsystem like this.
