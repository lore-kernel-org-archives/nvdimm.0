Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151111214435.GB95024@tevye.fc.hp.com>
References: <CAJN_NGaPbziX=OcyYpcn5TP76HwGQSTsUz-yOVGB2Sh8VxDQjA@mail.gmail.com>
	<20151109215904.GB33245@tevye.fc.hp.com>
	<CAJN_NGY0Zop4=_NrW8Y3md7Up9FRq9voQ2UYiTPgXCv9XP8u5A@mail.gmail.com>
	<20151111214435.GB95024@tevye.fc.hp.com>
Date: Thu, 12 Nov 2015 00:52:47 +0300
Message-ID: <CAJN_NGZufvD=GLkw2sscCOEdY9JB0ADSQzggrnEeeEGtdZkiOQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] nvdimm: Add IOCTL pass thru
From: Dmitry Krivenok <krivenok.dmitry@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Jerry Hoemann <Jerry.Hoemann@hpe.com>
Cc: ross.zwisler@linux.intel.com, rjw@rjwysocki.net, Len Brown <lenb@kernel.org>, dan.j.williams@intel.com, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

> but, we still want to go through entire list.

Shouldn't you break the loop immediately after you found the bus and sent ioctl?
Maybe I'm missing something, but I see no reason to continue iterating
after the bus was found (even though you don't do anything and just
compare IDs and "continue").
