Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1435482057.28808.2.camel@ingics.com>
References: <1435482057.28808.2.camel@ingics.com>
Date: Tue, 30 Jun 2015 11:37:30 -0700
Message-ID: <CAPcyv4gQOYzngAGCc2efNDgmPTz7EtkzriGzmeO4uQTdeW-qEg@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: Fix return value of nvdimm_bus_init() if
 class_create() fails
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Axel Lin <axel.lin@ingics.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Christoph Hellwig <hch@lst.de>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jun 28, 2015 at 2:00 AM, Axel Lin <axel.lin@ingics.com> wrote:
> Return proper error if class_create() fails.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Thanks, applied.
