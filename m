Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Mon, 30 Jan 2017 13:28:17 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 01/17] dax: refactor dax-fs into a generic provider
        of dax inodes
Message-ID: <20170130122817.GC9043@lst.de>
References: <148559256378.11180.8957776806175202312.stgit@dwillia2-desk3.amr.corp.intel.com> <148559256970.11180.2541041546993320141.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <148559256970.11180.2541041546993320141.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, snitzer@redhat.com, toshi.kani@hpe.com, mawilcox@microsoft.com, linux-block@vger.kernel.org, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org, ross.zwisler@linux.intel.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

I really don't like the dax_inode name.  Why not something like
dax_device or dax_region?
