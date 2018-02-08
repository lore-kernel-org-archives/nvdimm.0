Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22c.google.com (mail-ot0-x22c.google.com
 [IPv6:2607:f8b0:4003:c0f::22c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DABD22361E46
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 12:49:11 -0800 (PST)
Received: by mail-ot0-x22c.google.com with SMTP id m20so5640790otf.3
 for <linux-nvdimm@lists.01.org>; Thu, 08 Feb 2018 12:54:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180208204956.4821-1-vishal.l.verma@intel.com>
References: <20180208204956.4821-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 8 Feb 2018 12:54:55 -0800
Message-ID: <CAPcyv4jrtkoXH+pH1xDPatickpMpQLJqUciig1XaD=hqBw6u8Q@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm,
 testing: Add emulation for smart injection commands
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 8, 2018 at 12:49 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Add support for the smart injection command in the nvdimm unit test
> framework. This allows for directly injecting to smart fields and flags
> that are supported in the injection command. If the injected values are
> past the threshold, then an acpi notification is also triggered.
>
> Also update the default smart ctrl_temperature to start out below the
> default threshold instead of at it. This prevents arbitrary smart
> injections from triggering an acpi notification

Any sentence starting with "Also" in a changelog is almost always an
indication to split the patch in 2 so the topics can be independently
bisected.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
