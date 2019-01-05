Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from m12-17.163.com (m12-17.163.com [220.181.12.17])
 by ml01.01.org (Postfix) with ESMTP id 4CBC6211A45AB
 for <linux-nvdimm@lists.01.org>; Sat,  5 Jan 2019 00:09:06 -0800 (PST)
From: Xiaochun Lee <lixiaochun.2888@163.com>
Subject: [PATCH] ACPI/nfit: delete the function to_acpi_nfit_desc
Date: Sat,  5 Jan 2019 16:08:37 +0800
Message-Id: <1546675718-31174-1-git-send-email-lixiaochun.2888@163.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: rjw@rjwysocki.net, linux-kernel@vger.kernel.org, Xiaochun Lee <lixc17@lenovo.com>, zwisler@kernel.org, lenb@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Xiaochun Lee <lixc17@lenovo.com>

The function to_acpi_nfit_desc and function to_acpi_desc
do the same things,So delete the function to_acpi_nfit_desc,
and keep the inline function to_acpi_desc.

The calling function to_acpi_nfit_desc,have been changed 
to the calling function to_acpi_desc.

Xiaochun Lee (1):
  ACPI/nfit: delete the function to_acpi_nfit_desc

 drivers/acpi/nfit/core.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
