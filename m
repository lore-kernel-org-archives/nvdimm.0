Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 81AEE210D6CE6
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 22:11:31 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [qemu PATCH v4 0/4] support NFIT platform capabilities
Date: Fri, 1 Jun 2018 05:11:28 +0000
Message-ID: <AT5PR8401MB1169ACFF025365F3EDFE11BDAB620@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20180521163203.26590-1-ross.zwisler@linux.intel.com>
 <20180529195433.GA16151@linux.intel.com>
In-Reply-To: <20180529195433.GA16151@linux.intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Eduardo Habkost <ehabkost@redhat.com>, "Michael S . Tsirkin  <mst@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

> Ping on this series.  Rob, I think I've addressed all your feedback.
> Can you please verify?

I haven't tested it, but it reads OK.  I'm OK with just extending
the valid count for bits set to one for now; we can add a new
argument later if a need arises for extending it to express new bits
set to zero.


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
