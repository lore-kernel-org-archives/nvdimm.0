Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 17 Jun 2015 12:49:27 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v6 17/21] libnvdimm: infrastructure for btt devices
Message-ID: <20150617104927.GA8415@lst.de>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201142.25175.66768.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150611201142.25175.66768.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The block change need to be a separate patch.  They should go in through
Jens tree or at least get an ACK from him.

