Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0B9621B02822
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 00:11:37 -0700 (PDT)
Date: Thu, 27 Sep 2018 09:11:35 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 0/3] acpi, nfit: Add dirty shutdown count to sysfs
Message-ID: <20180927071135.GB6959@linux-x5ow.site>
References: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 26, 2018 at 09:24:20PM -0700, Dan Williams wrote:
> The Intel NVDIMM command specification publishes a dirty-shutdown-count
> in addition to the dirty-shutdown / flush-failed indication that comes
> from the ACPI NFIT. This is expected to be a common property of NVDIMMs
> and is a static hardware health detail to be cached / exported via
> sysfs.
> =

> Add plumbing for retrieving this data at driver load time, publish the
> count, and use the dynamically retrieved dirty-shutdown indicator to
> augment the existing 'flush_failed' flag.

Is this the same thing as the LSS Latch stuff that went into ndctl?

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
