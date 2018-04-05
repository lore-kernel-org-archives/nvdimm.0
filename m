From: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC] qemu: Add virtio pmem device
Date: Thu,  5 Apr 2018 16:18:34 +0530
Message-ID: <20180405104834.10457-4-pagupta@redhat.com>
References: <20180405104834.10457-1-pagupta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180405104834.10457-1-pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, qemu-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org
Cc: kwolf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org, xiaoguangrong.eric-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, niteshnarayanlal-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ross.zwisler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stefanha-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, imammedo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, nilal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

 This patch adds virtio-pmem Qemu device.

 This device configures memory address range information with file
 backend type. It acts like persistent memory device for KVM guest.
 It presents the memory address range to virtio-pmem driver over
 virtio channel and does the block flush whenever there is request
 from guest to flush/sync. (Qemu part for backing file flush
 is yet to be implemented).

 Current code is a RFC to support guest with persistent memory 
 range & DAX. 

Signed-off-by: Pankaj Gupta <pagupta-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 hw/virtio/Makefile.objs                     |   2 +-
 hw/virtio/virtio-pci.c                      |  44 +++++++++
 hw/virtio/virtio-pci.h                      |  14 +++
 hw/virtio/virtio-pmem.c                     | 133 ++++++++++++++++++++++++++++
 include/hw/pci/pci.h                        |   1 +
 include/hw/virtio/virtio-pmem.h             |  43 +++++++++
 include/standard-headers/linux/virtio_ids.h |   1 +
 7 files changed, 237 insertions(+), 1 deletion(-)
 create mode 100644 hw/virtio/virtio-pmem.c
 create mode 100644 include/hw/virtio/virtio-pmem.h

diff --git a/hw/virtio/Makefile.objs b/hw/virtio/Makefile.objs
index 765d363c1f..bb5573d2ef 100644
--- a/hw/virtio/Makefile.objs
+++ b/hw/virtio/Makefile.objs
@@ -5,7 +5,7 @@ common-obj-y += virtio-bus.o
 common-obj-y += virtio-mmio.o
 
 obj-y += virtio.o virtio-balloon.o 
-obj-$(CONFIG_LINUX) += vhost.o vhost-backend.o vhost-user.o
+obj-$(CONFIG_LINUX) += vhost.o vhost-backend.o vhost-user.o virtio-pmem.o
 obj-$(CONFIG_VHOST_VSOCK) += vhost-vsock.o
 obj-y += virtio-crypto.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio-crypto-pci.o
diff --git a/hw/virtio/virtio-pci.c b/hw/virtio/virtio-pci.c
index c20537f31d..114ca05497 100644
--- a/hw/virtio/virtio-pci.c
+++ b/hw/virtio/virtio-pci.c
@@ -2491,6 +2491,49 @@ static const TypeInfo virtio_rng_pci_info = {
     .class_init    = virtio_rng_pci_class_init,
 };
 
+/* virtio-pmem-pci */
+
+static void virtio_pmem_pci_realize(VirtIOPCIProxy *vpci_dev, Error **errp)
+{
+    VirtIOPMEMPCI *vpmem = VIRTIO_PMEM_PCI(vpci_dev);
+    DeviceState *vdev = DEVICE(&vpmem->vdev);
+
+    qdev_set_parent_bus(vdev, BUS(&vpci_dev->bus));
+    object_property_set_bool(OBJECT(vdev), true, "realized", errp);
+}
+
+static void virtio_pmem_pci_class_init(ObjectClass *klass, void *data)
+{
+    DeviceClass *dc = DEVICE_CLASS(klass);
+    VirtioPCIClass *k = VIRTIO_PCI_CLASS(klass);
+    PCIDeviceClass *pcidev_k = PCI_DEVICE_CLASS(klass);
+    k->realize = virtio_pmem_pci_realize;
+    set_bit(DEVICE_CATEGORY_MISC, dc->categories);
+    pcidev_k->vendor_id = PCI_VENDOR_ID_REDHAT_QUMRANET;
+    pcidev_k->device_id = PCI_DEVICE_ID_VIRTIO_PMEM;
+    pcidev_k->revision = VIRTIO_PCI_ABI_VERSION;
+    pcidev_k->class_id = PCI_CLASS_OTHERS;
+}
+
+static void virtio_pmem_pci_instance_init(Object *obj)
+{
+    VirtIOPMEMPCI *dev = VIRTIO_PMEM_PCI(obj);
+
+    virtio_instance_init_common(obj, &dev->vdev, sizeof(dev->vdev),
+                                TYPE_VIRTIO_PMEM);
+    object_property_add_alias(obj, "memdev", OBJECT(&dev->vdev), "memdev",
+                              &error_abort);
+}
+
+static const TypeInfo virtio_pmem_pci_info = {
+    .name          = TYPE_VIRTIO_PMEM_PCI,
+    .parent        = TYPE_VIRTIO_PCI,
+    .instance_size = sizeof(VirtIOPMEMPCI),
+    .instance_init = virtio_pmem_pci_instance_init,
+    .class_init    = virtio_pmem_pci_class_init,
+};
+
+
 /* virtio-input-pci */
 
 static Property virtio_input_pci_properties[] = {
@@ -2683,6 +2726,7 @@ static void virtio_pci_register_types(void)
     type_register_static(&virtio_balloon_pci_info);
     type_register_static(&virtio_serial_pci_info);
     type_register_static(&virtio_net_pci_info);
+    type_register_static(&virtio_pmem_pci_info);
 #ifdef CONFIG_VHOST_SCSI
     type_register_static(&vhost_scsi_pci_info);
 #endif
diff --git a/hw/virtio/virtio-pci.h b/hw/virtio/virtio-pci.h
index 813082b0d7..fe74fcad3f 100644
--- a/hw/virtio/virtio-pci.h
+++ b/hw/virtio/virtio-pci.h
@@ -19,6 +19,7 @@
 #include "hw/virtio/virtio-blk.h"
 #include "hw/virtio/virtio-net.h"
 #include "hw/virtio/virtio-rng.h"
+#include "hw/virtio/virtio-pmem.h"
 #include "hw/virtio/virtio-serial.h"
 #include "hw/virtio/virtio-scsi.h"
 #include "hw/virtio/virtio-balloon.h"
@@ -57,6 +58,7 @@ typedef struct VirtIOInputHostPCI VirtIOInputHostPCI;
 typedef struct VirtIOGPUPCI VirtIOGPUPCI;
 typedef struct VHostVSockPCI VHostVSockPCI;
 typedef struct VirtIOCryptoPCI VirtIOCryptoPCI;
+typedef struct VirtIOPMEMPCI VirtIOPMEMPCI;
 
 /* virtio-pci-bus */
 
@@ -274,6 +276,18 @@ struct VirtIOBlkPCI {
     VirtIOBlock vdev;
 };
 
+/*
+ * virtio-pmem-pci: This extends VirtioPCIProxy.
+ */
+#define TYPE_VIRTIO_PMEM_PCI "virtio-pmem-pci"
+#define VIRTIO_PMEM_PCI(obj) \
+        OBJECT_CHECK(VirtIOPMEMPCI, (obj), TYPE_VIRTIO_PMEM_PCI)
+
+struct VirtIOPMEMPCI {
+    VirtIOPCIProxy parent_obj;
+    VirtIOPMEM vdev;
+};
+
 /*
  * virtio-balloon-pci: This extends VirtioPCIProxy.
  */
diff --git a/hw/virtio/virtio-pmem.c b/hw/virtio/virtio-pmem.c
new file mode 100644
index 0000000000..28d06fc501
--- /dev/null
+++ b/hw/virtio/virtio-pmem.c
@@ -0,0 +1,133 @@
+/*
+ * Virtio pmem device
+ *
+ */
+
+
+#include "qemu/osdep.h"
+#include "qapi/error.h"
+#include "qemu-common.h"
+#include "qemu/error-report.h"
+#include "hw/virtio/virtio-pmem.h"
+
+
+static void virtio_pmem_system_reset(void *opaque)
+{
+
+}
+
+static void virtio_pmem_flush(VirtIODevice *vdev, VirtQueue *vq)
+{
+    VirtQueueElement *elem;
+
+    elem = virtqueue_pop(vq, sizeof(VirtQueueElement));
+    if (!elem) {
+        return;
+    }
+    /* todo flush raw file */
+
+    virtio_notify(vdev, vq);
+    g_free(elem);
+
+}
+
+static void virtio_pmem_get_config(VirtIODevice *vdev, uint8_t *config)
+{
+    VirtIOPMEM *pmem = VIRTIO_PMEM(vdev);
+    struct virtio_pmem_config *pmemcfg = (struct virtio_pmem_config *) config;
+
+    pmemcfg->start = pmem->start;
+    pmemcfg->size  = pmem->size;
+    pmemcfg->align = pmem->align;
+}
+
+static uint64_t virtio_pmem_get_features(VirtIODevice *vdev, uint64_t features,
+                                        Error **errp)
+{
+    virtio_add_feature(&features, VIRTIO_PMEM_PLUG);
+    return features;
+}
+
+
+static void virtio_pmem_realize(DeviceState *dev, Error **errp)
+{
+    VirtIODevice   *vdev   = VIRTIO_DEVICE(dev);
+    VirtIOPMEM     *pmem   = VIRTIO_PMEM(dev);
+    MachineState   *ms     = MACHINE(qdev_get_machine());
+    MemoryRegion   *mr;
+    PCMachineState *pcms   = PC_MACHINE(object_dynamic_cast(OBJECT(ms), TYPE_PC_MACHINE));
+    uint64_t addr;
+
+    if (!pmem->memdev) {
+        error_setg(errp, "virtio-pmem not set");
+        return;
+    }
+
+    mr               = host_memory_backend_get_memory(pmem->memdev, errp);
+    addr             = pcms->hotplug_memory.base;
+    pmem->start      = addr;
+    pmem->size       = memory_region_size(mr);
+    pmem->align      = memory_region_get_alignment(mr);
+
+    memory_region_init_alias(&pmem->mr, OBJECT(ms),
+                             "virtio_pmem-memory", mr, 0, pmem->size);
+
+    host_memory_backend_set_mapped(pmem->memdev, true);
+    virtio_init(vdev, TYPE_VIRTIO_PMEM, VIRTIO_ID_PMEM,
+                sizeof(struct virtio_pmem_config));
+
+    pmem->rq_vq = virtio_add_queue(vdev, 128, virtio_pmem_flush);
+    qemu_register_reset(virtio_pmem_system_reset, pmem);
+}
+
+static void virtio_mem_check_memdev(Object *obj, const char *name, Object *val,
+                                    Error **errp)
+{
+    if (host_memory_backend_is_mapped(MEMORY_BACKEND(val))) {
+
+        char *path = object_get_canonical_path_component(val);
+        error_setg(errp, "Can't use already busy memdev: %s", path);
+        g_free(path);
+        return;
+    }
+
+    qdev_prop_allow_set_link_before_realize(obj, name, val, errp);
+}
+
+static void virtio_pmem_instance_init(Object *obj)
+{
+
+    VirtIOPMEM *vm = VIRTIO_PMEM(obj);
+
+    object_property_add_link(obj, "memdev", TYPE_MEMORY_BACKEND,
+                             (Object **)&vm->memdev,
+                             (void *) virtio_mem_check_memdev,
+                             OBJ_PROP_LINK_UNREF_ON_RELEASE,
+                             &error_abort);
+}
+
+
+static void virtio_pmem_class_init(ObjectClass *klass, void *data)
+{
+    VirtioDeviceClass *vdc = VIRTIO_DEVICE_CLASS(klass);
+
+    vdc->realize      =  virtio_pmem_realize;
+    vdc->get_config   =  virtio_pmem_get_config;
+    vdc->get_features =  virtio_pmem_get_features;
+}
+
+static TypeInfo virtio_pmem_info = {
+    .name          = TYPE_VIRTIO_PMEM,
+    .parent        = TYPE_VIRTIO_DEVICE,
+    .class_size    = sizeof(VirtIOPMEM),
+    .class_init    = virtio_pmem_class_init,
+    .instance_init = virtio_pmem_instance_init,
+};
+
+
+static void virtio_register_types(void)
+{
+    type_register_static(&virtio_pmem_info);
+}
+
+type_init(virtio_register_types)
diff --git a/include/hw/pci/pci.h b/include/hw/pci/pci.h
index 15ced9648c..0f9091e6cc 100644
--- a/include/hw/pci/pci.h
+++ b/include/hw/pci/pci.h
@@ -85,6 +85,7 @@ extern bool pci_available;
 #define PCI_DEVICE_ID_VIRTIO_RNG         0x1005
 #define PCI_DEVICE_ID_VIRTIO_9P          0x1009
 #define PCI_DEVICE_ID_VIRTIO_VSOCK       0x1012
+#define PCI_DEVICE_ID_VIRTIO_PMEM        0x1013
 
 #define PCI_VENDOR_ID_REDHAT             0x1b36
 #define PCI_DEVICE_ID_REDHAT_BRIDGE      0x0001
diff --git a/include/hw/virtio/virtio-pmem.h b/include/hw/virtio/virtio-pmem.h
new file mode 100644
index 0000000000..f4be2f54f3
--- /dev/null
+++ b/include/hw/virtio/virtio-pmem.h
@@ -0,0 +1,43 @@
+/*
+ * Virtio pmem Device
+ *
+ *
+ */
+
+#ifndef QEMU_VIRTIO_PMEM_H
+#define QEMU_VIRTIO_PMEM_H
+
+#include "hw/virtio/virtio.h"
+#include "exec/memory.h"
+#include "sysemu/hostmem.h"
+#include "standard-headers/linux/virtio_ids.h"
+#include "hw/boards.h"
+#include "hw/i386/pc.h"
+
+#define VIRTIO_PMEM_PLUG 0
+
+#define TYPE_VIRTIO_PMEM "virtio-pmem"
+
+#define VIRTIO_PMEM(obj) \
+        OBJECT_CHECK(VirtIOPMEM, (obj), TYPE_VIRTIO_PMEM)
+
+typedef struct VirtIOPMEM {
+
+    VirtIODevice parent_obj;
+    VirtQueue *rq_vq;
+    uint64_t start;
+    uint64_t size;
+    uint64_t align;
+
+    MemoryRegion mr;
+    HostMemoryBackend *memdev;
+} VirtIOPMEM;
+
+struct virtio_pmem_config {
+
+    uint64_t start;
+    uint64_t size;
+    uint64_t align;
+};
+
+#endif
diff --git a/include/standard-headers/linux/virtio_ids.h b/include/standard-headers/linux/virtio_ids.h
index 6d5c3b2d4f..5ebd04980d 100644
--- a/include/standard-headers/linux/virtio_ids.h
+++ b/include/standard-headers/linux/virtio_ids.h
@@ -43,5 +43,6 @@
 #define VIRTIO_ID_INPUT        18 /* virtio input */
 #define VIRTIO_ID_VSOCK        19 /* virtio vsock transport */
 #define VIRTIO_ID_CRYPTO       20 /* virtio crypto */
+#define VIRTIO_ID_PMEM         21 /* virtio pmem */
 
 #endif /* _LINUX_VIRTIO_IDS_H */
-- 
2.14.3
