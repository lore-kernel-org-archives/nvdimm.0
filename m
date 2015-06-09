Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:44:25 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 18/21] nd_btt: atomic sector updates
Message-ID: <20150609064425.GF9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001546.4506.15713.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150602001546.4506.15713.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

I really want to see a good explanation why this is not a blk-mq driver
given that it does fairly substantial work and has synchronization
in its make_request function.
