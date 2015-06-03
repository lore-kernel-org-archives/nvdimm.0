Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1433345001.23540.157.camel@misato.fc.hp.com>
Subject: Re: [PATCH 3/3] libnvdimm: Add sysfs numa_node to NVDIMM devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Wed, 03 Jun 2015 09:23:21 -0600
In-Reply-To: <CAPcyv4i3LU2jXm3q1CDzgMAhzzpuYky1g8M6eT3wv_9BxsUnDA@mail.gmail.com>
References: <1433291212-23367-1-git-send-email-toshi.kani@hp.com>
	 <1433291212-23367-4-git-send-email-toshi.kani@hp.com>
	 <CAPcyv4hn_YX=atGXXEPaFf1xk2ZzaWgZjeTpPpEsZZdLiQCXAA@mail.gmail.com>
	 <CAPcyv4i3LU2jXm3q1CDzgMAhzzpuYky1g8M6eT3wv_9BxsUnDA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux ACPI <linux-acpi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-06-02 at 19:51 -0700, Dan Williams wrote:
> On Tue, Jun 2, 2015 at 6:01 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > On Tue, Jun 2, 2015 at 5:26 PM, Toshi Kani <toshi.kani@hp.com> wrote:
 :
> >>
> >> +#ifdef CONFIG_NUMA
> >> +static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
> >> +               char *buf)
> >> +{
> >> +       return sprintf(buf, "%d\n", dev->numa_node);
> >> +}
> >> +DEVICE_ATTR_RO(numa_node);
> >> +#endif
> >> +
> >>  static struct attribute *nd_device_attributes[] = {
> >>         &dev_attr_modalias.attr,
> >>         &dev_attr_devtype.attr,
> >> +#ifdef CONFIG_NUMA
> >> +       &dev_attr_numa_node.attr,
> >> +#endif
> >>         NULL,
> >>  };
> >
> > I'd prefer you define is_visible() in the nd_device_attribute_group
> > and gate showing this attribute on IS_ENABLED(CONFIG_NUMA) rather than
> > including these ifdef guards.  The ifdef guards aren't necessary in
> > the CONFIG_NUMA=n case.
> 
> I also think is_visible() should hide this attribute on is_nvdimm() devices.

Agreed.  Will do.

Thanks,
-Toshi

