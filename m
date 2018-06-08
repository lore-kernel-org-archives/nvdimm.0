Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E1A6E210EE4F3
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 09:14:30 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id a5-v6so16286319otf.12
 for <linux-nvdimm@lists.01.org>; Fri, 08 Jun 2018 09:14:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180608185714-mutt-send-email-mst@kernel.org>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-2-ross.zwisler@linux.intel.com>
 <20180608020724-mutt-send-email-mst@kernel.org>
 <5352d2fb-9244-78b0-4f4b-2818359a4425@redhat.com>
 <20180608153402.GA27156@linux.intel.com>
 <20180608185714-mutt-send-email-mst@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 8 Jun 2018 17:14:09 +0100
Message-ID: <CAFEAcA943cBfMbjBJcheTWAL+mWa4vu5uL62LvKXS4agd+ZRMA@mail.gmail.com>
Subject: Re: [Qemu-devel] [qemu PATCH 2/5] acpi: "make check" should fail on
 asl mismatch
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Thomas Huth <thuth@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On 8 June 2018 at 16:59, Michael S. Tsirkin <mst@redhat.com> wrote:
> The expected value tests are a debugging aid. They do not catch bugs and
> aren't designed to. In particular the comparisons do not even run if
> IASL isn't installed.

If they're not actually tests to catch bugs, maybe we shouldn't
be running them in "make check" ?

thanks
-- PMM
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
