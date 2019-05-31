Return-Path: <owner-linux-mm@kvack.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 1/8] acpi: Drop drivers/acpi/hmat/ directory
Date: Fri, 31 May 2019 10:23:55 +0200
Message-ID: <4965161.Uu1Nigf0I0@kreacher>
In-Reply-To: <155925716783.3775979.13301455166290564145.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155925716254.3775979.16716824941364738117.stgit@dwillia2-desk3.amr.corp.intel.com> <155925716783.3775979.13301455166290564145.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-efi@vger.kernel.org, Len Brown <lenb@kernel.org>, Keith Busch <keith.busch@intel.com>, vishal.l.verma@intel.com, ard.biesheuvel@linaro.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Friday, May 31, 2019 12:59:27 AM CEST Dan Williams wrote:
> As a single source file object there is no need for the hmat enabling to
> have its own directory.

Well, I asked Keith to add that directory as the code in hmat.c is more related to mm than to
the rest of the ACPI subsystem.

Is there any problem with retaining it?
