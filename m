Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1440772817-13562-1-git-send-email-toshi.kani@hp.com>
References: <1440772817-13562-1-git-send-email-toshi.kani@hp.com>
Date: Sat, 29 Aug 2015 08:22:27 -0700
Message-ID: <CAA9_cmdNBmOoyT90s5ONoEzwvWQvM7kTbwiXYEGDWfki+aaucg@mail.gmail.com>
Subject: Re: [PATCH]: acpica/nfit: Rename not-armed bit definition
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Toshi Kani <toshi.kani@hp.com>
Cc: rafael.j.wysocki@intel.com, robert.moore@intel.com, linux-acpi@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@acpica.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 28, 2015 at 7:40 AM, Toshi Kani <toshi.kani@hp.com> wrote:
> ACPI 6.0 NFIT Memory Device State Flags in Table 5-129 defines
> bit 3 as follows.
>
>   Bit [3] set to 1 to indicate that the Memory Device is observed
>   to be not armed prior to OSPM hand off. A Memory Device is
>   considered armed if it is able to accept persistent writes.
>
> This bit is currently defined as ACPI_NFIT_MEM_ARMED, which can be
> confusing as if the Memory Device is armed when this bit is set.
>
> Change the name to ACPI_NFIT_MEM_NOT_ARMED per the spec.
>
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>

Acked-by: Dan Williams <dan.j.williams@intel.com>
