Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F9BA211CD9AC
 for <linux-nvdimm@lists.01.org>; Sat, 23 Feb 2019 17:29:34 -0800 (PST)
Message-ID: <00540b00898a544b38a989b0b3b6c005fd50bef4.camel@kernel.org>
Subject: Re: [PATCH] dax: add a 'modalias' attribute to DAX 'bus' devices
From: Vishal Verma <vishal@kernel.org>
Date: Sat, 23 Feb 2019 18:29:32 -0700
In-Reply-To: <CAPcyv4ghTOwomME0GBuFi-ogfB7=D6kQMGR+Gb6b7cvMqLE4EA@mail.gmail.com>
References: <20190222235854.18927-1-vishal.l.verma@intel.com>
 <CAPcyv4ghTOwomME0GBuFi-ogfB7=D6kQMGR+Gb6b7cvMqLE4EA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2019-02-22 at 16:24 -0800, Dan Williams wrote:
> Looks ok, but I think the changelog could be more accurate.
> 
> On Fri, Feb 22, 2019 at 3:59 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > Add a 'modalias' attribute to devices under the DAX bus so that userspace
> > is able to dynamically load modules as needed.
> 
> The modalias is already published in the uevent which is how udev
> identifies the module. This patch would allow "modalias to module
> lookups" *outside* of the typical uevent used for dynamically loading
> modules.
> 
> Care to fix up the changelog with that detail and why userspace needs
> to do these lookups in addition to the typical uevent lookups?
> 

Yes, thanks for the feedback, I think this reads better:

8<----

>From 1e399f52f21c22e4c4bd5d48b26f539e12342beb Mon Sep 17 00:00:00 2001
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 22 Feb 2019 16:58:54 -0700
Subject: [PATCH v2] dax: add a 'modalias' attribute to DAX 'bus' devices

Add a 'modalias' attribute to devices under the DAX bus so that userspace
is able to dynamically load modules as needed.

Normally, udev can get the modalias from 'uevent', and that is correctly
set up by the DAX bus. However other tooling such as 'libndctl' for
interacting with drivers/nvdimm/, and 'libdaxctl' for drivers/dax/ can
also use the modalias to dynamically load modules via libkmod lookups.

The 'nd' bus set up by the libnvdimm subsystem exports a modalias
attribute. Imitate this to export the same for the 'dax' bus.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/dax/bus.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 28c3324271ac..2109cfe80219 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -295,6 +295,17 @@ static ssize_t target_node_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(target_node);
 
+static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
+		char *buf)
+{
+	/*
+	 * We only ever expect to handle device-dax instances, i.e. the
+	 * @type argument to MODULE_ALIAS_DAX_DEVICE() is always zero
+	 */
+	return sprintf(buf, DAX_DEVICE_MODALIAS_FMT "\n", 0);
+}
+static DEVICE_ATTR_RO(modalias);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int
n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -306,6 +317,7 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct
attribute *a, int n)
 }
 
 static struct attribute *dev_dax_attributes[] = {
+	&dev_attr_modalias.attr,
 	&dev_attr_size.attr,
 	&dev_attr_target_node.attr,
 	NULL,
-- 
2.20.1



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
