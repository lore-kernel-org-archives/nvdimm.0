Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1449038369-752-1-git-send-email-krivenok.dmitry@gmail.com>
References: <1449038369-752-1-git-send-email-krivenok.dmitry@gmail.com>
Date: Thu, 3 Dec 2015 18:52:53 -0800
Message-ID: <CAPcyv4grSUHnFv_8=V_rmFuoDHkY5LPWzUqD_p1hW+OQuYfBrQ@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: do not show pfn_seed for non pmem regions
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Krivenok" <krivenok.dmitry@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 1, 2015 at 10:39 PM, Dmitry V. Krivenok
<krivenok.dmitry@gmail.com> wrote:
> This simple change hides pfn_seed attribute for non pmem
> regions because they don't support pfn anyway.
>
> Signed-off-by: Dmitry V. Krivenok <krivenok.dmitry@gmail.com>
> ---

Looks good I'll queue it for 4.5.
