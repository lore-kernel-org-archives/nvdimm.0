Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151211180950.GA57513@tevye.fc.hp.com>
References: <cover.1449089647.git.jerry.hoemann@hpe.com>
	<f8e838fb666b7d05e5e1f7527d643181c6f6ba4d.1449089647.git.jerry.hoemann@hpe.com>
	<CAPcyv4gFNnsbyTy8u-_jBF9JPYH_0a9dNX_R1oj2EH2sdrb=-g@mail.gmail.com>
	<20151210002442.GA104756@tevye.fc.hp.com>
	<CAPcyv4guEsT0KKivDkKP3YiW=8Ps8cDkjzY0seQuec3mkg0wMg@mail.gmail.com>
	<20151211180950.GA57513@tevye.fc.hp.com>
Date: Fri, 11 Dec 2015 10:18:59 -0800
Message-ID: <CAPcyv4h-8bm4nxO=5K6vRb3720rtaW8A-VHWRaZAhyw0_tjrvg@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] nvdimm: Add IOCTL pass thru functions
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, jmoyer <jmoyer@redhat.com>, Dmitry Krivenok <krivenok.dmitry@gmail.com>, Linda Knippers <linda.knippers@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 11, 2015 at 10:09 AM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> On Wed, Dec 09, 2015 at 04:48:55PM -0800, Dan Williams wrote:
>> Yes, updating the acpi_evaluate_dsm() definition seems the best choice.
>>
>
> I have a patch for this.  While not big (6 files), these files are
> outside of nvdimm and will have a two line of over a dozen reviewers/lists
> not previously reviewing this series.

For an acpi change no need to cc all those folks and lists.  Just cc
the following for that change:

Bob Moore <robert.moore@intel.com>
Lv Zheng <lv.zheng@intel.com>
Rafael J. Wysocki <rafael.j.wysocki@intel.com>
<linux-acpi@vger.kernel.org>

Why 6 files and not 2 for a prototype update?  I wouldn't go touch
existing callers of acpi_evaluate_dsm() if they have been living with
the potential truncation all this time there's no need to change.

> Do you want me to send this patch as one of this series (w/ the
> extra reviewers?)

Yes, send that patch with the series so the acpi developers have the
context for what motivated the change.
