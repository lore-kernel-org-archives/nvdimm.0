Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24F1621123892
 for <linux-nvdimm@lists.01.org>; Fri,  8 Jun 2018 09:16:51 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id t133-v6so12304316oif.10
 for <linux-nvdimm@lists.01.org>; Fri, 08 Jun 2018 09:16:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180608190040-mutt-send-email-mst@kernel.org>
References: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
 <20180607223111.27792-2-ross.zwisler@linux.intel.com>
 <20180608020724-mutt-send-email-mst@kernel.org>
 <5352d2fb-9244-78b0-4f4b-2818359a4425@redhat.com>
 <20180608190040-mutt-send-email-mst@kernel.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 8 Jun 2018 17:16:30 +0100
Message-ID: <CAFEAcA-h3xxeRFO32pnqrwR_wZ1=us-t0FunS2aJRpQV==3-GQ@mail.gmail.com>
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

On 8 June 2018 at 17:03, Michael S. Tsirkin <mst@redhat.com> wrote:
> Pull requests are somewhat different, they are usually tested for lack
> of warnings. This change didn't arrive as a result of a pull request
> maybe that's why it slipped through the cracks. Peter?
>
> Maybe we need a "pedantic" flag to fail on any warnings, or just catch
> output to stderr.

If there's a situation that shouldn't exist in the tree (ie
a bug), then make check should catch it, and result in a
failure, not just printing random stuff to stderr. Otherwise
I'm not going to notice it, whether I'm applying a pull request
or an individual patch.

thanks
-- PMM
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
