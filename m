Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 0/3] Add NUMA support for NVDIMM devices
Date: Fri, 19 Jun 2015 02:43:54 +0200
Message-ID: <1458443.Tq20jlUN1c@vostro.rjw.lan>
In-Reply-To: <CAPcyv4i=wn+Nk_5HnyJrykZ4SaTTYAyc=aAajvSxXDpa+9aU0w@mail.gmail.com>
References: <1433891440-3515-1-git-send-email-toshi.kani@hp.com> <CAPcyv4i=wn+Nk_5HnyJrykZ4SaTTYAyc=aAajvSxXDpa+9aU0w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Rafael J Wysocki <rafael.j.wysocki@intel.com>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, June 18, 2015 01:24:01 PM Dan Williams wrote:
> Rafael, does patch1 look ok to you?

Mostly.  acpi_map_pxm_to_online_node() needs a proper kerneldoc comment
describing what it does.

Thanks,
Rafael

