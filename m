Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA4A3C27
	for <nvdimm@lists.linux.dev>; Sun, 29 Jan 2023 23:11:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=NQ7YgokTLfJq7c2D1zhGDjpisfmSP8xp8m3MmzMVL98=; b=tR5ChEh1M0Z7mmYghFZYDZkhYF
	VwsBdewvyOhjcUGdyWIEJ3H9OnSGJvzGgGGGZK6So26F8lFBlOPLSVyT2MgVqp0F/7kFDvXC0/wJF
	F8V88o2nnHVDmRqJkD+BL/KiXWv1Qm/VpDm8EvQqOCt6xD7Jf2tOAs/CfeuJLkkpjtQ6A3d9a7aIl
	HBWFgKjNcLjPBir7kxsZcNI6e0nzt4fhSIlVln5iSKgticGUPEh3W2m/O3n7k+jPNFAodh6KmJuNN
	sZE8ZbojS58xsI1pVvol23kXer5LTKxefgKbY9W0Us1t9+zMCnqXwf9SmPbfwDh5BVi7DqyzxV771
	6Mnq71Lw==;
Received: from [2601:1c2:d00:6a60::9526] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pMGp5-0020M2-Rb; Sun, 29 Jan 2023 23:10:55 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Tejun Heo <tj@kernel.org>,
	Zefan Li <lizefan.x@bytedance.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	cgroups@vger.kernel.org,
	Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	dm-devel@redhat.com,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	dmaengine@vger.kernel.org,
	Song Liu <song@kernel.org>,
	linux-raid@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org,
	Jean Delvare <jdelvare@suse.com>,
	Guenter Roeck <linux@roeck-us.net>,
	linux-hwmon@vger.kernel.org,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <quic_neeraju@quicinc.com>,
	Josh Triplett <josh@joshtriplett.org>,
	rcu@vger.kernel.org,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	sparclinux@vger.kernel.org
Subject: [PATCH 0/9] Documentation: correct lots of spelling errors (series 2)
Date: Sun, 29 Jan 2023 15:10:44 -0800
Message-Id: <20230129231053.20863-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Maintainers of specific kernel subsystems are only Cc-ed on their
respective patches, not the entire series. [if all goes well]

These patches are based on linux-next-20230127.


 [PATCH 1/9] Documentation: admin-guide: correct spelling
 [PATCH 2/9] Documentation: driver-api: correct spelling
 [PATCH 3/9] Documentation: hwmon: correct spelling
 [PATCH 4/9] Documentation: networking: correct spelling
 [PATCH 5/9] Documentation: RCU: correct spelling
 [PATCH 6/9] Documentation: scsi/ChangeLog*: correct spelling
 [PATCH 7/9] Documentation: scsi: correct spelling
 [PATCH 8/9] Documentation: sparc: correct spelling
 [PATCH 9/9] Documentation: userspace-api: correct spelling


 Documentation/RCU/Design/Expedited-Grace-Periods/Expedited-Grace-Periods.rst         |    6 -
 Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.rst                |    2 
 Documentation/RCU/RTFP.txt                                                           |   10 +-
 Documentation/RCU/UP.rst                                                             |    4 
 Documentation/RCU/lockdep.rst                                                        |    2 
 Documentation/RCU/torture.rst                                                        |    4 
 Documentation/admin-guide/bcache.rst                                                 |    2 
 Documentation/admin-guide/cgroup-v1/blkio-controller.rst                             |    2 
 Documentation/admin-guide/cgroup-v2.rst                                              |   10 +-
 Documentation/admin-guide/cifs/usage.rst                                             |    4 
 Documentation/admin-guide/device-mapper/cache-policies.rst                           |    2 
 Documentation/admin-guide/device-mapper/dm-ebs.rst                                   |    2 
 Documentation/admin-guide/device-mapper/dm-zoned.rst                                 |    2 
 Documentation/admin-guide/device-mapper/unstriped.rst                                |   10 +-
 Documentation/admin-guide/dynamic-debug-howto.rst                                    |    2 
 Documentation/admin-guide/gpio/gpio-sim.rst                                          |    2 
 Documentation/admin-guide/hw-vuln/mds.rst                                            |    4 
 Documentation/admin-guide/kernel-parameters.txt                                      |    8 -
 Documentation/admin-guide/laptops/thinkpad-acpi.rst                                  |    2 
 Documentation/admin-guide/md.rst                                                     |    2 
 Documentation/admin-guide/media/bttv.rst                                             |    2 
 Documentation/admin-guide/media/building.rst                                         |    2 
 Documentation/admin-guide/media/si476x.rst                                           |    2 
 Documentation/admin-guide/media/vivid.rst                                            |    2 
 Documentation/admin-guide/mm/hugetlbpage.rst                                         |    2 
 Documentation/admin-guide/mm/numa_memory_policy.rst                                  |    4 
 Documentation/admin-guide/perf/hns3-pmu.rst                                          |    2 
 Documentation/admin-guide/pm/amd-pstate.rst                                          |    2 
 Documentation/admin-guide/spkguide.txt                                               |    4 
 Documentation/admin-guide/sysctl/vm.rst                                              |    4 
 Documentation/admin-guide/sysrq.rst                                                  |    2 
 Documentation/driver-api/dma-buf.rst                                                 |    2 
 Documentation/driver-api/dmaengine/client.rst                                        |    2 
 Documentation/driver-api/dmaengine/dmatest.rst                                       |    2 
 Documentation/driver-api/hsi.rst                                                     |    4 
 Documentation/driver-api/io-mapping.rst                                              |    4 
 Documentation/driver-api/md/md-cluster.rst                                           |    2 
 Documentation/driver-api/md/raid5-cache.rst                                          |    2 
 Documentation/driver-api/media/drivers/vidtv.rst                                     |    2 
 Documentation/driver-api/media/dtv-demux.rst                                         |    2 
 Documentation/driver-api/media/v4l2-subdev.rst                                       |    4 
 Documentation/driver-api/mei/nfc.rst                                                 |    2 
 Documentation/driver-api/nfc/nfc-hci.rst                                             |    2 
 Documentation/driver-api/nvdimm/nvdimm.rst                                           |    2 
 Documentation/driver-api/nvdimm/security.rst                                         |    2 
 Documentation/driver-api/pin-control.rst                                             |    2 
 Documentation/driver-api/pldmfw/index.rst                                            |    2 
 Documentation/driver-api/serial/driver.rst                                           |    2 
 Documentation/driver-api/surface_aggregator/ssh.rst                                  |    2 
 Documentation/driver-api/thermal/intel_powerclamp.rst                                |    2 
 Documentation/driver-api/usb/dwc3.rst                                                |    2 
 Documentation/driver-api/usb/usb3-debug-port.rst                                     |    2 
 Documentation/hwmon/aht10.rst                                                        |    2 
 Documentation/hwmon/aspeed-pwm-tacho.rst                                             |    2 
 Documentation/hwmon/corsair-psu.rst                                                  |    2 
 Documentation/hwmon/gsc-hwmon.rst                                                    |    6 -
 Documentation/hwmon/hwmon-kernel-api.rst                                             |    4 
 Documentation/hwmon/ltc2978.rst                                                      |    2 
 Documentation/hwmon/max6697.rst                                                      |    2 
 Documentation/hwmon/menf21bmc.rst                                                    |    2 
 Documentation/hwmon/pmbus-core.rst                                                   |    2 
 Documentation/hwmon/sht4x.rst                                                        |    2 
 Documentation/hwmon/smm665.rst                                                       |    2 
 Documentation/hwmon/stpddc60.rst                                                     |    2 
 Documentation/hwmon/vexpress.rst                                                     |    2 
 Documentation/hwmon/via686a.rst                                                      |    2 
 Documentation/networking/af_xdp.rst                                                  |    4 
 Documentation/networking/arcnet-hardware.rst                                         |    2 
 Documentation/networking/can.rst                                                     |    2 
 Documentation/networking/can_ucan_protocol.rst                                       |    2 
 Documentation/networking/cdc_mbim.rst                                                |    2 
 Documentation/networking/device_drivers/atm/iphase.rst                               |    2 
 Documentation/networking/device_drivers/can/ctu/ctucanfd-driver.rst                  |    4 
 Documentation/networking/device_drivers/can/ctu/fsm_txt_buffer_user.svg              |    4 
 Documentation/networking/device_drivers/ethernet/3com/vortex.rst                     |    2 
 Documentation/networking/device_drivers/ethernet/aquantia/atlantic.rst               |    6 -
 Documentation/networking/device_drivers/ethernet/freescale/dpaa2/mac-phy-support.rst |    2 
 Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst               |    2 
 Documentation/networking/device_drivers/ethernet/pensando/ionic.rst                  |    2 
 Documentation/networking/device_drivers/ethernet/ti/am65_nuss_cpsw_switchdev.rst     |    2 
 Documentation/networking/device_drivers/ethernet/ti/cpsw_switchdev.rst               |    2 
 Documentation/networking/device_drivers/wwan/iosm.rst                                |    2 
 Documentation/networking/devlink/ice.rst                                             |    4 
 Documentation/networking/devlink/netdevsim.rst                                       |    2 
 Documentation/networking/devlink/prestera.rst                                        |    2 
 Documentation/networking/dsa/configuration.rst                                       |    2 
 Documentation/networking/ethtool-netlink.rst                                         |    6 -
 Documentation/networking/gtp.rst                                                     |    2 
 Documentation/networking/ieee802154.rst                                              |    2 
 Documentation/networking/ip-sysctl.rst                                               |    6 -
 Documentation/networking/ipvlan.rst                                                  |    2 
 Documentation/networking/j1939.rst                                                   |    2 
 Documentation/networking/net_failover.rst                                            |    2 
 Documentation/networking/netconsole.rst                                              |    2 
 Documentation/networking/page_pool.rst                                               |    6 -
 Documentation/networking/phonet.rst                                                  |    2 
 Documentation/networking/phy.rst                                                     |    2 
 Documentation/networking/regulatory.rst                                              |    4 
 Documentation/networking/rxrpc.rst                                                   |    2 
 Documentation/networking/snmp_counter.rst                                            |    4 
 Documentation/networking/sysfs-tagging.rst                                           |    2 
 Documentation/scsi/ChangeLog.lpfc                                                    |   36 ++++----
 Documentation/scsi/ChangeLog.megaraid                                                |    8 -
 Documentation/scsi/ChangeLog.megaraid_sas                                            |    4 
 Documentation/scsi/ChangeLog.ncr53c8xx                                               |   16 +--
 Documentation/scsi/ChangeLog.sym53c8xx                                               |   14 +--
 Documentation/scsi/ChangeLog.sym53c8xx_2                                             |   10 +-
 Documentation/scsi/ncr53c8xx.rst                                                     |    4 
 Documentation/scsi/sym53c8xx_2.rst                                                   |    2 
 Documentation/scsi/tcm_qla2xxx.rst                                                   |    2 
 Documentation/scsi/ufs.rst                                                           |    2 
 Documentation/sparc/adi.rst                                                          |    4 
 Documentation/sparc/oradax/dax-hv-api.txt                                            |   44 +++++-----
 Documentation/userspace-api/iommufd.rst                                              |    2 
 Documentation/userspace-api/media/drivers/st-vgxy61.rst                              |    2 
 Documentation/userspace-api/media/rc/lirc-set-wideband-receiver.rst                  |    2 
 Documentation/userspace-api/media/rc/rc-protos.rst                                   |    2 
 Documentation/userspace-api/media/rc/rc-tables.rst                                   |    2 
 Documentation/userspace-api/media/v4l/dev-sliced-vbi.rst                             |    2 
 Documentation/userspace-api/media/v4l/ext-ctrls-codec-stateless.rst                  |    2 
 Documentation/userspace-api/media/v4l/ext-ctrls-jpeg.rst                             |    2 
 Documentation/userspace-api/media/v4l/hist-v4l2.rst                                  |    4 
 Documentation/userspace-api/media/v4l/pixfmt-yuv-luma.rst                            |    2 
 Documentation/userspace-api/media/v4l/vidioc-cropcap.rst                             |    2 
 Documentation/userspace-api/seccomp_filter.rst                                       |    2 
 Documentation/userspace-api/sysfs-platform_profile.rst                               |    2 
 126 files changed, 232 insertions(+), 232 deletions(-)


Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@kernel.org>
Cc: dm-devel@redhat.com
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: nvdimm@lists.linux.dev
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Jean Delvare <jdelvare@suse.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: linux-hwmon@vger.kernel.org
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Neeraj Upadhyay <quic_neeraju@quicinc.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: rcu@vger.kernel.org
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Cc: sparclinux@vger.kernel.org
