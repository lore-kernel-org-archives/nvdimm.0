Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 17 Dec 2015 12:07:12 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: -next regression: "driver cohandle -EPROBE_DEFER from
 bus_type.match()"
Message-ID: <20151217170712.GE2457@linux.intel.com>
References: <CAPcyv4hOJuT=i2A_0vDQHsL7MXNgVN_p17q3UW6EcTkxsCMmeg@mail.gmail.com>
 <CAPcyv4h1yhyqxdyLka2X56Q5QhCoXY3vALFBdm0gdQdYR6Vr8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4h1yhyqxdyLka2X56Q5QhCoXY3vALFBdm0gdQdYR6Vr8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>, Stephen Rothwell <sfr@canb.auug.org.au>, tomeu.vizoso@collabora.com, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, m.szyprowski@samsung.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 17, 2015 at 08:48:09AM -0800, Dan Williams wrote:
> On Thu, Dec 17, 2015 at 7:51 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> How about just checking for EPROBE_DEFER, every other non-zero value is success.

How about using IS_ERR_VALUE()?  If it's good enough for IS_ERR(),
it's good enough for this case.
