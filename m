Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151109215904.GB33245@tevye.fc.hp.com>
References: <CAJN_NGaPbziX=OcyYpcn5TP76HwGQSTsUz-yOVGB2Sh8VxDQjA@mail.gmail.com>
	<20151109215904.GB33245@tevye.fc.hp.com>
Date: Tue, 10 Nov 2015 18:05:15 +0300
Message-ID: <CAJN_NGY0Zop4=_NrW8Y3md7Up9FRq9voQ2UYiTPgXCv9XP8u5A@mail.gmail.com>
Subject: Re: [PATCH 3/4] nvdimm: Add IOCTL pass thru
From: Dmitry Krivenok <krivenok.dmitry@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, Len Brown <lenb@kernel.org>, dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> Is your concern readibility or size of generated code (or both?)
>
> I'll look to consolidating the debug printing in next version as additional patch.

Just a minor style comment, not critical.

> If we had a longer list, I would definitely say yes.  Not so sure with
> just two types.  I'll take a look for the next version.

The same, just a style comment.

>   list_for_each_entry(nvdimm_bus, &nvdimm_bus_list, list) {
> - if (nvdimm_bus->id == id) {
> + if (nvdimm_bus->id != id)

I noticed another minor issue. You have switched from "==" to "!="
here, but you didn't add "break" after ioctl is handled for the found
bus.

Thanks,
Dmitry
